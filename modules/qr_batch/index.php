<?php
/* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version 4.0                                                  |
  | http://www.issabel.org                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2021 Issabel Foundation                                |
  +----------------------------------------------------------------------+
  | The contents of this file are subject to the General Public License  |
  | (GPL) Version 2 (the "License"); you may not use this file except in |
  | compliance with the License. You may obtain a copy of the License at |
  | http://www.opensource.org/licenses/gpl-license.php                   |
  |                                                                      |
  | Software distributed under the License is distributed on an "AS IS"  |
  | basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  |
  | the License for the specific language governing rights and           |
  | limitations under the License.                                       |
  +----------------------------------------------------------------------+
*/

function _moduleContent(&$smarty, $module_name)
{

    include_once "libs/paloSantoConfig.class.php";
    include_once "libs/misc.lib.php";

    require_once "modules/$module_name/configs/default.conf.php";
    require_once "modules/$module_name/libs/IssabelQRConfig.class.php";

    load_language_module($module_name);

    //global variables
    global $arrConf;
    global $arrConfModule;

    $arrConf = array_merge($arrConf,$arrConfModule);

    //folder path for custom templates
    $base_dir = dirname($_SERVER['SCRIPT_FILENAME']);
    $templates_dir = (isset($arrConf['templates_dir'])) ? $arrConf['templates_dir'] : 'themes';
    $local_templates_dir = "$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    $myQR = new IssabelQRConfig();
    $allips = $myQR->getIPs();
    $templates = $myQR->getAvailableTemplates();

    /* El campo de Host/IP es un input con datalist: no hay opción preseleccionada
     * por el navegador como en un <select>, así que el valor por defecto se fija
     * aquí. Se conserva el que llegue por POST para no perderlo al recargar. */
    $asteriskIp = getParameter('asteriskip');
    if (!is_string($asteriskIp) || trim($asteriskIp) === '') {
        $asteriskIp = count($allips) > 0 ? $allips[0] : '';
    } else {
        $asteriskIp = trim($asteriskIp);
    }

    $smarty->assign(array(
        'MODULE_NAME'       =>  $module_name,
        'LABEL_QR'          =>  _tr("Display List of QR Configuration codes"),
        'ISSABEL_HOST_IP'   =>  _tr("Issabel Host/IP Address"),
        'ALL_IP'            =>  $allips,
        'ASTERISK_IP'       =>  $asteriskIp,
        'HOSTNAME'          =>  _qrBatchHostname(),
        'TEMPLATES'         =>  $templates,
        'QRCODE_GENERATOR'  =>  _tr("Generate QR Code list for softphones"),
        'GENERATE'          =>  _tr("Generate"),
        'BRAND'             =>  _tr("Phone Brand"),
        'CLOSE'             =>  _tr("Close"),
    ));

    switch (getParameter('action')) {
    case 'qrlist':
        return qr_list($smarty, $local_templates_dir, $_REQUEST);
    default:
        return $smarty->fetch("$local_templates_dir/qrbatch.tpl");
    }
}

/* Sugerencia para el datalist: el host con el que se está abriendo la GUI, que
 * es el que usan los softphones. Se sanea antes de pintarlo. */
function _qrBatchHostname()
{
    $host = isset($_SERVER['HTTP_HOST']) ? (string)$_SERVER['HTTP_HOST'] : '';
    return preg_match('/^[A-Za-z0-9._:\[\]-]{1,255}$/', $host) ? $host : '';
}

function qr_list($smarty, $local_templates_dir, $request)
{
    $myQR = new IssabelQRConfig();

    $pLoadExtension = build_extensionsBatch($smarty);
    if (is_null($pLoadExtension)) {
        // build_extensionsBatch() ya dejó el motivo en errMsg; sin esta salida
        // se seguía con una llamada a método sobre null (error fatal en PHP 8).
        return '<div class="iss-alert iss-alert--error"><div class="iss-alert__content">'
            .htmlentities(_tr('Error when connecting to database'), ENT_COMPAT, 'UTF-8')
            .'</div></div>';
    }
    $r = $pLoadExtension->queryExtensions();

    $brand    = isset($request['template']) ? $request['template'] : '';
    $template = $myQR->getTemplate($brand);

    $server_ip = isset($request['asteriskip']) ? trim($request['asteriskip']) : '';
    if (!is_array($r)) {
        print htmlentities($pLoadExtension->errMsg, ENT_COMPAT, 'UTF-8');
        return;
    }
    $codes=array();
    $names=array();

    foreach ($r as $tupla) {
        if(preg_match("/sip/i",$tupla['tech'])) {
            $extension = $tupla['extension'];
            $name      = $tupla['name'];
            $secret    = $tupla['parameters']['secret'];
            $qrcode = $myQR->generateQR($extension,$name,$secret,$server_ip,$template);
            $codes[$extension]=$qrcode;
            $names[$extension]=$name;
        }
    }
    $smarty->assign("codes", $codes);
    $smarty->assign("names", $names);

    return $smarty->fetch("$local_templates_dir/qrlist.tpl");
}

function build_extensionsBatch($smarty)
{
    require_once "libs/paloSantoConfig.class.php";
    require_once "modules/extensions_batch/libs/paloSantoExtensionsBatch.class.php";

    $pConfig = new paloConfig("/etc", "amportal.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrAMP  = $pConfig->leer_configuracion(false);

    $dsnAsterisk = $arrAMP['AMPDBENGINE']['valor']."://".
                   $arrAMP['AMPDBUSER']['valor']. ":".
                   $arrAMP['AMPDBPASS']['valor']. "@".
                   $arrAMP['AMPDBHOST']['valor']. "/asterisk";

    $pDB = new paloDB($dsnAsterisk);
    if(!empty($pDB->errMsg)) {
        // El llamador imprime el aviso: aquí sólo se informa el motivo.
        return NULL;
    }

    $pConfig = new paloConfig($arrAMP['ASTETCDIR']['valor'], "asterisk.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrAST  = $pConfig->leer_configuracion(false);

    return new paloSantoExtensionsBatch($pDB, $arrAST, $arrAMP);
}


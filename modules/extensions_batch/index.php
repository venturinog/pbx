<?php
/* vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4:
  Codificación: UTF-8
  +----------------------------------------------------------------------+
  | Issabel version 1.0                                                  |
  | http://www.issabel.org                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2006 Palosanto Solutions S. A.                         |
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
  | The Initial Developer of the Original Code is PaloSanto Solutions    |
  +----------------------------------------------------------------------+
  $Id: index.php, Wed 28 Apr 2021 10:16:09 AM EDT, nicolas@issabel.com
*/
function _moduleContent(&$smarty, $module_name)
{
    require_once "modules/$module_name/configs/default.conf.php";
    require_once "modules/$module_name/libs/paloSantoExtensionsBatch.class.php";
	
    load_language_module($module_name);
    
    //global variables
    global $arrConf;
    global $arrConfModule;
    $arrConf = array_merge($arrConf,$arrConfModule);

    //folder path for custom templates
    $base_dir = dirname($_SERVER['SCRIPT_FILENAME']);
    $templates_dir = (isset($arrConf['templates_dir'])) ? $arrConf['templates_dir'] : 'themes';
    $local_templates_dir = "$base_dir/modules/$module_name/".$templates_dir.'/'.$arrConf['theme'];

    switch (getParameter('action')) {
    case 'csvdownload':
        return download_csv($smarty);
    default:
        return display_form($smarty, $module_name, $local_templates_dir);
    }
}

function setNotice(&$smarty, $sMessage, $sType = 'error', $sTitle = '')
{
    $smarty->assign('NOTICE', $sMessage);
    $smarty->assign('NOTICE_TYPE', $sType);
    $smarty->assign('NOTICE_TITLE', $sTitle);
}

function display_form($smarty, $module_name, $local_templates_dir)
{
    require_once "libs/paloSantoForm.class.php";

	if (getParameter('csvupload') != '') {
		upload_csv($smarty, $module_name);
	}
    if (getParameter('delete_all') != '') {
    	delete_extensions($smarty, $module_name);
    }
    
    $smarty->assign(array(
        'MODULE_NAME'       =>  $module_name,
        'LABEL_FILE'        =>  _tr("File"),
        'LABEL_UPLOAD'      =>  _tr('Save'),
        'LABEL_DOWNLOAD'    =>  _tr("Download Extensions"),
        'LABEL_DELETE'      =>  _tr('Delete All Extensions'),
        'CONFIRM_DELETE'    =>  _tr("Are you really sure you want to delete all the extensions in this server?"),
        'HeaderFile'        =>  _tr("Header File Extensions Batch"),
        'AboutUpdate'       =>  _tr("About Update Extensions Batch"),
    ));
    
    $oForm = new paloForm($smarty, array());
    return $oForm->fetchForm("$local_templates_dir/extension.tpl", _tr('Extensions Batch'), $_POST);
}

function download_csv($smarty)
{
    header('Cache-Control: private');
    header('Pragma: cache');
    header('Content-Type: text/csv; charset=utf-8; header=present');
    header('Content-disposition: attachment; filename=extensions.csv');

    $pLoadExtension = build_extensionsBatch($smarty);
    if (is_null($pLoadExtension)) return;
    $r = $pLoadExtension->queryExtensions();
    
    if (!is_array($r)) {
        print htmlentities($pLoadExtension->errMsg, ENT_COMPAT, 'UTF-8');
        return;
    }
    
    $keyOrder = $pLoadExtension->getFieldTitles();
    print '"'.implode('","', $keyOrder)."\"\n";
    
    
    foreach ($r as $tupla) {

        $t = array();
        foreach (array_keys($keyOrder) as $k)
            $t[] = isset($tupla[$k]) 
                ? $tupla[$k] 
                : (isset($tupla['parameters'][$k]) ? $tupla['parameters'][$k] 
                : (isset($tupla['parameters'][key_dictionary($k)]) ? $tupla['parameters'][key_dictionary($k)] : ''));
        print '"'.implode('","', $t)."\"\n";
    }
}

function key_dictionary($key) {
  $dict = array (
     "icesupport"     => "ice_support",
     "dtlsverify"     => "dtls_verify",
     "dtlssetup"      => "dtls_setup",
     "dtlscertfile"   => "dtls_cert_file",
     "dtlsprivatekey" => "dtls_private_key",
     "dtlscafile"     => "dtls_ca_file",
     "avpf"           => "use_avpf",
     "encryption"     => "media_encryption"
  );

  return isset($dict[$key])?$dict[$key]:$key;
}

function delete_extensions($smarty, $module_name)
{
    $pLoadExtension = build_extensionsBatch($smarty);
    if (is_null($pLoadExtension)) return;
    $r = $pLoadExtension->deleteExtensions();
    if ($r) {
        setNotice($smarty, _tr('All extensions deletes'), 'success', _tr('Message'));
    } else {
        setNotice($smarty, _tr('Could not delete the database').': '.$pLoadExtension->errMsg, 'error', _tr('ERROR'));
    }
}

function upload_csv($smarty, $module_name)
{
    if (!preg_match('/.csv$/', $_FILES['csvfile']['name'])) {
        setNotice($smarty, _tr('Invalid file extension.- It must be csv'), 'error', _tr('Validation Error'));
        return;
    }
    if (!is_uploaded_file($_FILES['csvfile']['tmp_name'])) {
        setNotice($smarty, _tr('Possible file upload attack. Filename') ." :". $_FILES['csvfile']['name'], 'error', _tr('ERROR'));
        return;
    }

    $pLoadExtension = build_extensionsBatch($smarty);
    if (is_null($pLoadExtension)) return;
    if (!$pLoadExtension->loadExtensionsCSV($_FILES['csvfile']['tmp_name'])) {
        setNotice($smarty, $pLoadExtension->errMsg, 'error', _tr('ERROR'));
        return;
    }
    if (!$pLoadExtension->applyExtensions()) {
        setNotice($smarty, $pLoadExtension->errMsg, 'error', _tr('ERROR'));
        return;
    }
    setNotice($smarty, _tr('Total extension updated').": ".$pLoadExtension->getNumBatch(), 'success', _tr('Message'));
}

function build_extensionsBatch($smarty)
{
    require_once "libs/paloSantoConfig.class.php";

    $pConfig = new paloConfig("/etc", "amportal.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrAMP  = $pConfig->leer_configuracion(false);

    $dsnAsterisk = $arrAMP['AMPDBENGINE']['valor']."://".
                   $arrAMP['AMPDBUSER']['valor']. ":".
                   $arrAMP['AMPDBPASS']['valor']. "@".
                   $arrAMP['AMPDBHOST']['valor']. "/asterisk";

    $pDB = new paloDB($dsnAsterisk);
    if(!empty($pDB->errMsg)) {
        setNotice($smarty, _tr('Error when connecting to database').': '.$pDB->errMsg, 'error', _tr('ERROR'));
        return NULL;
    }

    $pConfig = new paloConfig($arrAMP['ASTETCDIR']['valor'], "asterisk.conf", "=", "[[:space:]]*=[[:space:]]*");
    $arrAST  = $pConfig->leer_configuracion(false);

    return new paloSantoExtensionsBatch($pDB, $arrAST, $arrAMP);
}
?>

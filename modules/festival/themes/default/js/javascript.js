$(document).ready(function () {

    /* El aviso se inserta en la propia página del módulo: bajo el layout de
     * pestañas el iframe sólo imprime el contenido del módulo, así que los
     * contenedores de los temas legacy no existen y el mensaje nunca se veía.
     * Los colores salen del tema (STYLE.md §3.1 y §3.2).
     */
    function showMessage(data) {
        $('#festival-message').remove();
        if (!data || (!data.mb_title && !data.mb_message)) return;

        var type = (data.type === 'success') ? 'success' : 'error';
        var alert = $('<div class="iss-alert" id="festival-message">' +
            '<div class="iss-alert__title"></div>' +
            '<div class="iss-alert__content"></div></div>');
        alert.addClass('iss-alert--' + type);
        alert.find('.iss-alert__title').text(data.mb_title || '');
        alert.find('.iss-alert__content').text(data.mb_message || '');

        var form = $('.iss-form').first();
        if (form.length) {
            form.before(alert);
        } else {
            $('#issabel_framework_module_id').after(alert);
        }
    }

    var labels = window.ISSABEL_FESTIVAL || {};

    $(":checkbox[name='chkoldstatus']").iButton({
        labelOn: labels.on || 'On',
        labelOff: labels.off || 'Off',
        change: function ($input) {
            var festival_activate = $input.is(":checked") ? "activate" : "deactivate";
            $("#status").val(festival_activate);

            var arrAction            = new Array();
            arrAction["action"]  = "change";
            arrAction["menu"]    = "festival";
            arrAction["rawmode"] = "yes";
            arrAction["status"]  = festival_activate;
            request("index.php", arrAction, false,
                function (arrData, statusResponse, error) {
                    showMessage(arrData);
                });
        }
    });
});

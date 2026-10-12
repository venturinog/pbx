<form method='POST' enctype='multipart/form-data' style='margin-bottom:0;' action='?menu={$MODULE_NAME}'>
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons" style="margin-left:0;">
      <input class="button" type="submit" name="csvupload" value="{$LABEL_UPLOAD}">
      <input class='button' type='submit' name='delete_all' value='{$LABEL_DELETE}' onClick="return confirmSubmit('{$CONFIRM_DELETE}');">
    </div>
  </div>
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-file-upload"></i> {$LABEL_FILE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$LABEL_FILE}</span>
        <span class="iss-field__control"><input type='file' id='csvfile' name='csvfile' /></span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$AboutUpdate}</span>
        <span class="iss-field__control">
          <a class="button" href="?menu={$MODULE_NAME}&amp;action=csvdownload&amp;rawmode=yes"><i class="ti ti-download"></i> {$LABEL_DOWNLOAD}</a>
        </span>
        {$HeaderFile}
      </div>
    </div>
  </section>
</form>

<form method="POST" enctype="multipart/form-data" action="?menu={$MODULE_NAME}">
{if $NOTICE}
<div class="iss-alert iss-alert--{$NOTICE_TYPE|default:'error'}">
  {if $NOTICE_TITLE}<div class="iss-alert__title">{$NOTICE_TITLE|escape}</div>{/if}
  <div class="iss-alert__content">{$NOTICE|escape}</div>
</div>
{/if}
<div class="iss-form">
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="csvupload" value="{$LABEL_UPLOAD}">
      <input class="button" type="submit" name="delete_all" value="{$LABEL_DELETE}" onClick="return confirmSubmit('{$CONFIRM_DELETE}');">
    </div>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-file-upload"></i> {$LABEL_FILE}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$LABEL_FILE}</span>
        <span class="iss-field__control">
          <input class="form-control" type="file" id="csvfile" name="csvfile">
        </span>
        <span class="iss-field__help">{$HeaderFile}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$AboutUpdate}</span>
        <span class="iss-field__control">
          <a class="button" href="?menu={$MODULE_NAME}&amp;action=csvdownload&amp;rawmode=yes"><i class="ti ti-download"></i> {$LABEL_DOWNLOAD}</a>
        </span>
      </div>
    </div>
  </section>
</div>
</form>

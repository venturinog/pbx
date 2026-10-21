<form method="POST" enctype="multipart/form-data" action="{$url_edit}">
<div class="iss-form">
  {if $msg_status}
  <div class="iss-alert iss-alert--{$MSG_STATUS_TYPE|default:'error'}">
    <div class="iss-alert__content">{$msg_status}</div>
  </div>
  {/if}

  <div class="iss-form__toolbar">
    <div class="iss-form__buttons">
      <a class="button" href="{$url_back}&file={$search}"><i class="ti ti-arrow-left"></i> {$LABEL_BACK}</a>
      <input class="button" type="submit" name="Guardar" value="{$LABEL_SAVE}">
      <input class="button" type="submit" name="Reload" value="{$RELOAD_ASTERISK}">
    </div>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-file-text"></i> {$title}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$basename.LABEL}{$LABEL_COMPLETADO}</span>
        <span class="iss-field__control">{$basename.INPUT}</span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$content.LABEL}</span>
        <span class="iss-field__control">{$content.INPUT}</span>
      </div>
    </div>
  </section>
</div>
</form>

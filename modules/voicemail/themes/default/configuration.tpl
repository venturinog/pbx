<form method="POST">
<div class="iss-form">
  <div class="iss-form__toolbar">
    {if $mode ne 'view'}
      <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    {/if}
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="save" value="{$SAVE}">
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
  </div>
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$status.LABEL}</span>
        <span class="iss-field__control">{$status.INPUT}</span>
      </div>
      <div class="iss-field iss-span2">
        <span></span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$email.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$email.INPUT}</span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$pager_email.LABEL}</span>
        <span class="iss-field__control">{$pager_email.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$password.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$password.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$password_confir.LABEL}&nbsp;<span class="iss-required">*</span></span>
        <span class="iss-field__control">{$password_confir.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$email_attach.LABEL}</span>
        <span class="iss-field__control">{$email_attach.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$play_cid.LABEL}</span>
        <span class="iss-field__control">{$play_cid.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$play_envelope.LABEL}</span>
        <span class="iss-field__control">{$play_envelope.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$delete_vmail.LABEL}</span>
        <span class="iss-field__control">{$delete_vmail.INPUT}</span>
      </div>
    </div>
  </section>
</div>
</form>

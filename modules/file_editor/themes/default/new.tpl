<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$file.LABEL}</span>
        <span class="iss-field__control">{$file.INPUT}</span>
      </div>
      {if $msj_err}
      <div class="iss-field iss-field--full">
        <div class="iss-alert iss-alert--error">
          <div class="iss-alert__content">{$msj_err|escape}</div>
        </div>
      </div>
      {/if}
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="filter" value="{$Filter}">
      </div>
    </div>
  </section>
</div>

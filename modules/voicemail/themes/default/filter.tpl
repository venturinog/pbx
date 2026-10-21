<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_start.LABEL}</span>
        <span class="iss-field__control">{$date_start.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}</span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__hint">
        <a href="javascript:seleccionar_checkbox(1)">{$LBL_CHECK_ALL}</a>
        <a href="javascript:seleccionar_checkbox(0)">{$LBL_UNCHECK_ALL}</a>
      </div>
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="filter" value="{$Filter}">
      </div>
    </div>
  </section>
</div>

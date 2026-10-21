{if $accion eq "show_callers"}
<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$device.LABEL}</span>
        <span class="iss-field__control">{$device.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="update_show_callers" value="{$UPDATE}">
        <input class="button" type="submit" name="cancel" value="{$CANCEL}">
        <input class="button" type="submit" name="caller_invite" value="{$INVITE_CALLER}">
        <input class="button" type="submit" name="callers_kick_all" value="{$KICK_ALL}">
      </div>
    </div>
  </section>
</div>
{else}
<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$conference.LABEL}</span>
        <span class="iss-field__control">{$conference.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$filter.LABEL}</span>
        <span class="iss-field__control">{$filter.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="show" value="{$SHOW}">
      </div>
    </div>
  </section>
</div>
{/if}

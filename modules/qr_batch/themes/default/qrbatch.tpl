<form method="POST" action="?menu={$MODULE_NAME}">
{$ISSABEL_CSRF_FIELD}
<input type="hidden" name="action" value="qrlist">

<div class="iss-form">
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="generate" value="{$GENERATE}">
    </div>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-qrcode"></i> {$QRCODE_GENERATOR}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$BRAND}</span>
        <span class="iss-field__control">
          <select name="template" id="template" class="form-select">
          {foreach $TEMPLATES as $template}
            <option value="{$template}">{$template}</option>
          {/foreach}
          </select>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$ISSABEL_HOST_IP}</span>
        <span class="iss-field__control">
          <input class="form-control" type="text" name="asteriskip" id="asteriskip"
                 value="{$ASTERISK_IP|escape}" list="issabel-ip-list" autocomplete="off">
          <datalist id="issabel-ip-list">
          {foreach $ALL_IP as $ip}
            <option value="{$ip|escape}"></option>
          {/foreach}
          {if $HOSTNAME}
            <option value="{$HOSTNAME|escape}"></option>
          {/if}
          </datalist>
        </span>
      </div>
    </div>
  </section>
</div>
</form>

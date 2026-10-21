<form method="POST">
{literal}
<script type="text/javascript">
<!-- Original:  Gregor (legreg@legreg.de) -->
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Begin
var ie4 = (document.all) ? true : false;
var ns4 = (document.layers) ? true : false;
var ns6 = (document.getElementById && !document.all) ? true : false;
function hidelayer(lay) {
if (ie4) {
    document.all[lay].style.visibility = "hidden";
    document.all[lay].style.position = "absolute";
}
if (ns4) {
    document.layers[lay].visibility = "hide";
}
if (ns6) {
    document.getElementById([lay]).style.display = "none";
    document.getElementById([lay]).style.position = "absolute";
}
}
function showlayer(lay) {
if (ie4) {
    document.all[lay].style.visibility = "visible";
    document.all[lay].style.position = "";
}
if (ns4) {
    document.layers[lay].visibility = "show";
}
if (ns6) {
    document.getElementById([lay]).style.display = "";
    document.getElementById([lay]).style.position = "";
}
}
//  End -->
</script>
{/literal}

<div class="iss-form">
  <div class="iss-form__toolbar">
    {if $mode ne 'view'}
      <span class="iss-form__hint"><span class="iss-required">*</span> {$REQUIRED_FIELD}</span>
    {/if}
    <div class="iss-form__buttons">
      {if $Show}
        <input class="button" type="submit" name="add_conference" value="{$SAVE}">
      {/if}
      <input class="button" type="submit" name="cancel" value="{$CANCEL}">
    </div>
  </div>

  <section class="iss-card">
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$conference_name.LABEL}{if $mode ne 'view'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$conference_name.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$conference_owner.LABEL}</span>
        <span class="iss-field__control">{$conference_owner.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$moderator_pin.LABEL}</span>
        <span class="iss-field__control">{$moderator_pin.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$moderator_options_1.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">{$moderator_options_1.INPUT}{$announce}</span>
          <span class="iss-inline-field">{$moderator_options_2.INPUT}{$record}</span>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$user_pin.LABEL}</span>
        <span class="iss-field__control">{$user_pin.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$user_options_1.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">{$user_options_1.INPUT}{$announce}</span>
          <span class="iss-inline-field">{$user_options_2.INPUT}{$listen_only}</span>
          <span class="iss-inline-field">{$user_options_3.INPUT}{$wait_for_leader}</span>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$start_time.LABEL}{if $mode ne 'view'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$start_time.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$duration.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">
            <span>{$duration.INPUT}&nbsp;:&nbsp;{$duration_min.INPUT}</span>
          </span>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$conference_number.LABEL}{if $mode ne 'view'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$conference_number.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$max_participants.LABEL}{if $mode ne 'view'}&nbsp;<span class="iss-required">*</span>{/if}</span>
        <span class="iss-field__control">{$max_participants.INPUT}</span>
      </div>

{if $WEBCONF_CONTENT}
      <div class="iss-field iss-field--full">
        <label class="iss-inline-field">
          <input type="checkbox" name="enable_webconf" id="enable_webconf" {$WEBCONF_SELECTED} {literal} onclick="if (this.checked) { showlayer('webconf_options'); } else { hidelayer('webconf_options'); } " {/literal} />
          {$enable_web_conf}
        </label>
      </div>
      <div class="iss-field iss-field--full" id="webconf_options">{$WEBCONF_CONTENT}</div>
{literal}
<script type="text/javascript">
<!--

if (document.getElementById('enable_webconf').checked) {
    showlayer('webconf_options');
} else {
    hidelayer('webconf_options');
}

//  End -->
</script>
{/literal}
{/if}
    </div>
  </section>
</div>
</form>

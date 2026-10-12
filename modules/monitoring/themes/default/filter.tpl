<a class="btn btn-primary" data-bs-toggle="collapse" href="#filters" role="button" aria-haspopup="true" aria-expanded="false" aria-controls="filters">
<i class="ti ti-filter"></i> {$FILTER_SHOW}
<i class="ti ti-chevron-down"></i>
</a>

<div class="collapse" id="filters">
<form id=formFilter method="POST" action="">
<div class="iss-form" style="margin-bottom:1.25rem;">
  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-filter"></i> {$FILTER_SHOW}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field">
        <span class="iss-field__label">{$date_start.LABEL}</span>
        <span class="iss-field__control">{$date_start.INPUT}</span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$date_end.LABEL}</span>
        <span class="iss-field__control">{$date_end.INPUT}</span>
      </div>
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$filter_field.LABEL}</span>
        <span class="iss-field__control">
          <span class="iss-inline-field">
            {$filter_field.INPUT}{$filter_value.INPUT}
            <select id="filter_value_recordingfile" name="filter_value_recordingfile" size="1" style="display:none">
              <option value="incoming" {$SELECTED_1} >{$INCOMING}</option>
              <option value="outgoing" {$SELECTED_2} >{$OUTGOING}</option>
              <option value="queue" {$SELECTED_3} >{$QUEUE}</option>
              <option value="group" {$SELECTED_4} >{$GROUP}</option>
            </select>
          </span>
        </span>
      </div>
      <div class="iss-field">
        <span class="iss-field__label">{$limit.LABEL}</span>
        <span class="iss-field__control">{$limit.INPUT}</span>
      </div>
    </div>
    <div class="iss-form__toolbar" style="border-top:1px solid var(--iss-border); margin:0; padding:12px 18px; border-bottom:0;">
      <div class="iss-form__buttons">
        <input class="button" type="submit" name="show" value="{$SHOW}" />
      </div>
    </div>
  </section>
</div>
</form>
</div>

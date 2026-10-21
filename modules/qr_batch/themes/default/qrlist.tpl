<div class="iss-form">
  <form method="post" class="iss-form__toolbar">
    {$ISSABEL_CSRF_FIELD}
    <input type="hidden" name="action" value="form">
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="close" value="{$CLOSE}">
    </div>
  </form>

  <section class="iss-card">
    <div class="iss-card__body">
      <div class="iss-formgrid iss-formgrid--3col">
        {foreach $names as $extension=>$name}
        <div class="iss-field">
          <span class="iss-field__label">{$extension} &mdash; {$name|escape}</span>
          <span class="iss-field__control">
            <img src="data:image/png;base64,{$codes[$extension]}" alt="{$extension}" width="200" height="200">
          </span>
        </div>
        {/foreach}
      </div>
    </div>
  </section>
</div>

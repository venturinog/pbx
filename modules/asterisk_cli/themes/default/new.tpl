<form method="POST" enctype="multipart/form-data">
<div class="iss-form">
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons">
      <input class="button" type="submit" name="execute" value="{$execute}">
    </div>
  </div>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-terminal-2"></i> {$asterisk}</header>
    <div class="iss-card__body iss-formgrid">
      <div class="iss-field iss-field--full">
        <span class="iss-field__label">{$command}</span>
        <span class="iss-field__control">
          <input class="form-control" type="text" name="txtCommand" size="70" value="{$txtCommand}" autocomplete="off">
        </span>
      </div>
    </div>
  </section>

  <section class="iss-card">
    <header class="iss-card__header"><i class="ti ti-code"></i> {$result}</header>
    <div class="iss-card__body">
      <div class="iss-console"><pre>{$RESPUESTA_SHELL}</pre></div>
    </div>
  </section>
</div>
</form>

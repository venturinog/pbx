<div class="iss-form">
  <div class="iss-form__toolbar">
    <div class="iss-form__buttons" style="margin-left:0;">
      <input class="button" type="submit" name="save" value="{$SAVE}" {$DISABLED}/>
    </div>
  </div>

  <section class="iss-card">
    <div class="iss-card__body">
      <div class="iss-form__toolbar" style="margin:0 0 14px;">
        <label class="iss-inline-field">
          <input type="radio" name="option_record" id="record_by_phone" value="by_record" {$check_record} onclick="Activate_Option_Record()" />
          {$record}
        </label>
        <label class="iss-inline-field">
          <input type="radio" name="option_record" id="record_by_file" value="by_file" {$check_file} onclick="Activate_Option_Record()" />
          {$file_upload}
        </label>
      </div>
      <div class="iss-formgrid" id="record_option">
        <div class="iss-field">
          <span class="iss-field__label">{$recording_name_Label} <span class="iss-field__help">[.gsm|.wav]</span></span>
          <span class="iss-field__control">
            <input size='30' name="recording_name" id="recording_name" type="text" value="{$filename}" class="form-control" />
            <input class="button" title={$record} type="submit" name="record" id="record" value="{$record}" {$DISABLED}/>
          </span>
        </div>
      </div>
      <div class="iss-formgrid" id="upload_option">
        <div class="iss-field">
          <span class="iss-field__label">{$record_Label}</span>
          <span class="iss-field__control">
            <input name="file_record" id="file_record" type="file" value="{$file_record_name}" size='30' {$DISABLED}/>
          </span>
        </div>
      </div>
    </div>
  </section>

  <section class="iss-card" id="info">
    <div class="iss-card__body iss-field__help">
      <p class="iss-field__help">{$NAME}</p>
      <p class="iss-field__help" style="margin:0;">{$INFO}</p>
    </div>
  </section>
</div>
<input type='hidden' name='filename' value='{$filename}' />

{literal}
    <script type="text/javascript">
        Activate_Option_Record();

        function Activate_Option_Record()
        {
            var record_by_phone = document.getElementById('record_by_phone');
            var record_by_file = document.getElementById('record_by_file');
            if(record_by_phone.checked==true)
            {
                document.getElementById('record_option').style.display = '';
                document.getElementById('info').style.display = '';
                document.getElementById('upload_option').style.display = 'none';
            }
            else
            {
                document.getElementById('record_option').style.display = 'none';
                document.getElementById('info').style.display = 'none';
                document.getElementById('upload_option').style.display = '';
            }
        }
    </script>
{/literal}

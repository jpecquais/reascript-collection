-- @noindex

local module = {}

local function set_button_state(sec, cmd, state)
    reaper.SetToggleCommandState( sec, cmd, state and 1 or 0 ) -- Set OFF
    reaper.RefreshToolbar2( sec, cmd )
end   

local function make_button(command_name)
    local button = {}

    local sec = 0
    button.cmd = reaper.NamedCommandLookup(command_name)
    button.state = (reaper.GetToggleCommandStateEx(sec, button.cmd)>0)
    button.linked_buttons = {}
    button.inv_linked_buttons = {}
    button.callback = nil

    function button:attach_callback(callback)
        self.callback = callback
    end
    
    function button:set_state(state)
        self.state = state
        set_button_state(sec,button.cmd,state)
    end

    function button:toggle()
        local new_state = not self.state
        if new_state then
        self:set_state(new_state)
            for _, btn in pairs(self.linked_buttons) do
                btn:set_state(new_state)
            end
            for _, btn in pairs(self.inv_linked_buttons) do
                btn:set_state(not new_state)
            end
        end
        self:callback()
    end

    return button
end

local function group_buttons(buttons, inv)
    for i, button in ipairs(buttons) do
        for j, other_button in ipairs(buttons) do
            if button.cmd ~= other_button.cmd then
                if inv then
                    table.insert(button.inv_linked_buttons, other_button)
                else
                    table.insert(button.linked_buttons, other_button)
                end
            end
        end
    end
end

module.stereo_input_button          = make_button("_RS81669e975861809eeb710c39ff02fad4be2d61fd")
module.hoa_input_button             = make_button("_RSd43cf49b10bb5c88b8682fc4ced3a739e981da22")
module.speaker_pair_output_button   = make_button("_RS4f06feb4519da598adfe119aaf2657445dfa6c18")
module.headphone_output_button      = make_button("_RSd624c46310aa2485bd3fc6c01de91d3e3e3a2bc3")
module.speakers_output_button       = make_button("_RS450cda376b777c446da5bfeb769ee338b86e1003")
module.uhj_output_button            = make_button("_RS330ce2d34169148a760db0ad557f957daa5d309b")

group_buttons({module.stereo_input_button,
               module.hoa_input_button},true)
group_buttons({module.speaker_pair_output_button,
               module.headphone_output_button,
               module.speakers_output_button,
               module.uhj_output_button},true)

local function perform()

    local stereo_input_state = module.stereo_input_button.state
    local hoa_input_state = module.hoa_input_button.state
    local speaker_pair_output_state = module.speaker_pair_output_button.state
    local speakers_output_state = module.speakers_output_button.state
    local headphone_output_state = module.headphone_output_button.state
    local uhj_output_state = module.uhj_output_button.state

    local master_track   = reaper.GetMasterTrack(0)

    local stereo2ambi    = reaper.TrackFX_AddByName(master_track, "Stereo2Ambisonic", true, 0)
    local ambi2bin       = reaper.TrackFX_AddByName(master_track, "Ambisonic2Binaural", true, 0)
    local bin2transaural = reaper.TrackFX_AddByName(master_track, "Binaural2Transaural", true, 0)
    local ambi2uhj       = reaper.TrackFX_AddByName(master_track, "Ambisonic2UHJ", true, 0)
    local ambi2speakers  = reaper.TrackFX_AddByName(master_track, "Ambisonic2Speakers", true, 0)

    local function set_master_fx_bypass_state(fx, state)
        local monitor_fx_offset = 16777216
        local monitor_fx_location = monitor_fx_offset+fx
        local bypass = reaper.TrackFX_GetNumParams(master_track, monitor_fx_location)-3
        reaper.TrackFX_SetParamNormalized(master_track, monitor_fx_location, bypass, state)
    end
    
    local function set_stereo2ambi_bypass_state(state)
        set_master_fx_bypass_state(stereo2ambi,state)
    end
    
    local function set_ambi2bin_bypass_state(state)
        set_master_fx_bypass_state(ambi2bin,state)
    end
    
    local function set_bin2transaural_bypass_state(state)
        set_master_fx_bypass_state(bin2transaural,state)
    end
    
    local function set_ambi2uhj_bypass_state(state)
        set_master_fx_bypass_state(ambi2uhj,state)
    end
    
    local function set_ambi2speakers_bypass_state(state)
        set_master_fx_bypass_state(ambi2speakers,state)
    end 

    if stereo_input_state and headphone_output_state then
        set_stereo2ambi_bypass_state(0)
        set_ambi2bin_bypass_state(0)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(1)
        set_ambi2speakers_bypass_state(1)
    elseif stereo_input_state and uhj_output_state then
        set_stereo2ambi_bypass_state(0)
        set_ambi2bin_bypass_state(1)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(0)
        set_ambi2speakers_bypass_state(1)
    elseif stereo_input_state and (speaker_pair_output_state or speakers_output_state) then
        set_stereo2ambi_bypass_state(1)
        set_ambi2bin_bypass_state(1)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(1)
        set_ambi2speakers_bypass_state(1)
    elseif hoa_input_state and headphone_output_state then
        set_stereo2ambi_bypass_state(1)
        set_ambi2bin_bypass_state(0)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(1)
        set_ambi2speakers_bypass_state(1)
    elseif hoa_input_state and speaker_pair_output_state then
        set_stereo2ambi_bypass_state(1)
        set_ambi2bin_bypass_state(0)
        set_bin2transaural_bypass_state(0)
        set_ambi2uhj_bypass_state(1)
        set_ambi2speakers_bypass_state(1)
    elseif hoa_input_state and uhj_output_state then
        set_stereo2ambi_bypass_state(1)
        set_ambi2bin_bypass_state(1)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(0)
        set_ambi2speakers_bypass_state(1)
    elseif hoa_input_state and speakers_output_state then
        set_stereo2ambi_bypass_state(1)
        set_ambi2bin_bypass_state(1)
        set_bin2transaural_bypass_state(1)
        set_ambi2uhj_bypass_state(1)
        set_ambi2speakers_bypass_state(0)
    end
end

module.stereo_input_button:attach_callback(perform)          
module.hoa_input_button:attach_callback(perform)             
module.speaker_pair_output_button:attach_callback(perform)   
module.headphone_output_button:attach_callback(perform)      
module.speakers_output_button:attach_callback(perform)       
module.uhj_output_button:attach_callback(perform)            

return module
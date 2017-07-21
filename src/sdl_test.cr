require "./sdl_test/*"

@[Link("gl")]
lib LibGL
  alias Enum = UInt32
  alias Boolean = UInt8
  alias Float = Float32
  alias Double = Float64
  alias Bitfield = UInt32
  alias UInt = UInt32
  alias SizeI = Int32
  alias Int = Int32

  alias Char = UInt8

  alias SizeIPtr = Int32

  DEPTH_BUFFER_BIT   = 0x00000100_u32
  COLOR_BUFFER_BIT   = 0x00004000_u32
  ARRAY_BUFFER       = 0x00008892_u32
  STATIC_DRAW        = 0x000088E4_u32
  VERTEX_ARRAY       = 0x00008074_u32
  VERTEX_SHADER      = 0x00008B31_u32
  FRAGMENT_SHADER    = 0x00008B30_u32
  COMPILE_STATUS     = 0x00008B81_u32
  LINK_STATUS        = 0x00008B82_u32
  INFO_LOG_LENGTH    = 0x00008B84_u32

  FLOAT = 0x00001406_u32
  FALSE = 0_u8
  TRIANGLES = 0x00000004_u32

  fun clear_color = glClearColor(red: Float, green: Float, blue: Float, alpha: Float) : Void
  fun clear_depth = glClearDepth(depth : Double) : Void
  fun clear = glClear(mask: Bitfield) : Void
  fun gen_buffers = glGenBuffers(n : SizeI, ids : UInt*) : Void
  fun bind_buffer = glBindBuffer(target : Enum, id : UInt) : Void
  fun buffer_data = glBufferData(target : Enum, size : SizeIPtr, data : Void*, usage : Enum) : Void
  fun enable_vertex_attrib_array = glEnableVertexAttribArray(index : UInt) : Void
  fun disable_vertex_attrib_array = glDisableVertexAttribArray(index : UInt) : Void
  fun enable_client_state = glEnableClientState(cap : Enum) : Void
  fun disable_client_state = glDisableClientState(cap : Enum) : Void
  fun vertex_attrib_pointer = glVertexAttribPointer(index : UInt, size : Int, type : Enum, normalized : Boolean, stride : SizeI, pointer : Void*) : Void
  fun gen_vertex_arrays = glGenVertexArrays(n : SizeI, ids : UInt*) : Void
  fun bind_vertex_array = glBindVertexArray(id : UInt) : Void
  fun draw_arrays = glDrawArrays(mode : Enum, first : Int, count : SizeI) : Void

  fun create_shader = glCreateShader(shaderType : Enum) : UInt
  fun shader_source = glShaderSource(shader : UInt, count : SizeI, string : Char**, length : Int*) : Void
  fun compile_shader = glCompileShader(shader : UInt) : Void
  fun get_shader_iv = glGetShaderiv(shader : UInt, pname : Enum, params : Int*) : Void
  fun get_shader_info_log = glGetShaderInfoLog(shader : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  fun create_program = glCreateProgram() : UInt
  fun attach_shader = glAttachShader(program : UInt, shader : UInt) : Void
  fun link_program = glLinkProgram(program : UInt) : Void
  fun get_program_iv = glGetProgramiv(program : UInt, pname : Enum, params : Int*) : Void
  fun get_program_info_log = glGetProgramInfoLog(program : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  fun bind_attrib_location = glBindAttribLocation(program : UInt, index : UInt, name : Char*) : Void
  fun use_program = glUseProgram(program : UInt) : Void

end

module GL
  struct Color4
    property :red, :green, :blue, :alpha
    def initialize(@red : Float = 1.0, @green : Float = 1.0, @blue : Float = 1.0, @alpha : Float = 1.0)
      
    end

    def inspect
      "red: #{red}, green: #{green}, blue: #{blue}, alpha: #{alpha}"
    end
  end

  module ColorBuffer
    def self.clear(color : Color4? = nil)
      if color
        LibGL.clear_color(color.red, color.green, color.blue, color.alpha)
      end
      LibGL.clear(LibGL::COLOR_BUFFER_BIT)
    end
  end
end

@[Link("glew")]
lib LibGLEW
  OK = 0

  $experimental = glewExperimental : LibGL::Boolean

  fun init = glewInit() : Int32
end

@[Link("sdl2")]
lib LibSDL
  fun init = SDL_Init(flags: UInt32) : Int32
  fun quit = SDL_Quit() : Void
  fun poll_event = SDL_PollEvent(event : Event*) : Int32
  fun gl_get_swap_interval = SDL_GL_GetSwapInterval() : Int32
  fun gl_set_swap_interval = SDL_GL_SetSwapInterval(interval : Int32) : Int32

  enum EventType : UInt32
    FIRSTEVENT = 0x0000
    QUIT = 0x0100

    # MacOS events
    APP_TERMINATING
    APP_LOWMEMORY
    APP_WILLENTERBACKGROUND
    APP_DIDENTERBACKGROUND
    APP_WILLENTERFOREGROUND
    APP_DIDENTERFOREGROUND

    # SDL_Window events
    WINDOWEVENT = 0x0200
    SYSWMEVENT

    # Keyboard events
    KEYDOWN = 0x0300
    KEYUP
    TEXTEDITING
    TEXTINPUT

    # Mouse events
    MOUSEMOTION = 0x0400
    MOUSEBUTTONDOWN
    MOUSEBUTTONUP
    MOUSEWHEEL

    # Joystick events
    JOYAXISMOTION = 0x0600
    JOYBALLMOTION
    JOYHATMOTION
    JOYBUTTONDOWN
    JOYBUTTONUP
    JOYDEVICEADDED
    JOYDEVICEREMOVED

    # Game controller events
    CONTROLLERAXISMOTION = 0x0650
    CONTROLLERBUTTONDOWN
    CONTROLLERBUTTONUP
    CONTROLLERDEVICEADDED
    CONTROLLERDEVICEREMOVED
    CONTROLLERDEVICEREMAPPED

    # Touch events
    FINGERDOWN = 0x0700
    FINGERUP
    FINGERMOTION

    # Gesture events
    DOLLARGESTURE = 0x0800
    DOLLARRECORD
    MULTIGESTURE

    # Clipboard events
    CLIPBOARDUPDATE = 0x0900

    # Drag and drop events
    DROPFILE = 0x1000

    # Custom event space
    # Register with SDL_RegisterEvents
    USEREVENT = 0x8000

    LASTEVENT = 0xFFFF
  end

  union Event
    type : EventType
    quit : QuitEvent
    key : KeyboardEvent
  end

  struct KeyboardEvent
    type : EventType
    timestamp : UInt32
    windowID : UInt32
    state : UInt8
    repeat : UInt8
    padding2 : UInt8
    padding3 : UInt8
    keysym : Keysym
  end

  SDLK_SCANCODE_MASK = 1 << 30

  enum Scancode
    UNKNOWN = 0

    # Usage page 0x07

    A = 4
    B = 5
    C = 6
    D = 7
    E = 8
    F = 9
    G = 10
    H = 11
    I = 12
    J = 13
    K = 14
    L = 15
    M = 16
    N = 17
    O = 18
    P = 19
    Q = 20
    R = 21
    S = 22
    T = 23
    U = 24
    V = 25
    W = 26
    X = 27
    Y = 28
    Z = 29

    KEY_1 = 30
    KEY_2 = 31
    KEY_3 = 32
    KEY_4 = 33
    KEY_5 = 34
    KEY_6 = 35
    KEY_7 = 36
    KEY_8 = 37
    KEY_9 = 38
    KEY_0 = 39

    RETURN = 40
    ESCAPE = 41
    BACKSPACE = 42
    TAB = 43
    SPACE = 44

    MINUS = 45
    EQUALS = 46
    LEFTBRACKET = 47
    RIGHTBRACKET = 48
    BACKSLASH = 49
    NONUSHASH = 50
    SEMICOLON = 51
    APOSTROPHE = 52
    GRAVE = 53
    COMMA = 54
    PERIOD = 55
    SLASH = 56

    CAPSLOCK = 57

    F1 = 58
    F2 = 59
    F3 = 60
    F4 = 61
    F5 = 62
    F6 = 63
    F7 = 64
    F8 = 65
    F9 = 66
    F10 = 67
    F11 = 68
    F12 = 69

    PRINTSCREEN = 70
    SCROLLLOCK = 71
    PAUSE = 72
    INSERT = 73
    HOME = 74
    PAGEUP = 75
    DELETE = 76
    END = 77
    PAGEDOWN = 78
    RIGHT = 79
    LEFT = 80
    DOWN = 81
    UP = 82

    NUMLOCKCLEAR = 83
    KP_DIVIDE = 84
    KP_MULTIPLY = 85
    KP_MINUS = 86
    KP_PLUS = 87
    KP_ENTER = 88
    KP_1 = 89
    KP_2 = 90
    KP_3 = 91
    KP_4 = 92
    KP_5 = 93
    KP_6 = 94
    KP_7 = 95
    KP_8 = 96
    KP_9 = 97
    KP_0 = 98
    KP_PERIOD = 99

    NONUSBACKSLASH = 100
    APPLICATION = 101
    POWER = 102
    KP_EQUALS = 103
    F13 = 104
    F14 = 105
    F15 = 106
    F16 = 107
    F17 = 108
    F18 = 109
    F19 = 110
    F20 = 111
    F21 = 112
    F22 = 113
    F23 = 114
    F24 = 115
    EXECUTE = 116
    HELP = 117
    MENU = 118
    SELECT = 119
    STOP = 120
    AGAIN = 121
    UNDO = 122
    CUT = 123
    COPY = 124
    PASTE = 125
    FIND = 126
    MUTE = 127
    VOLUMEUP = 128
    VOLUMEDOWN = 129
    # LOCKINGCAPSLOCK = 130
    # LOCKINGNUMLOCK = 131
    # LOCKINGSCROLLLOCK = 132
    KP_COMMA = 133
    KP_EQUALSAS400 = 134

    INTERNATIONAL1 = 135
    INTERNATIONAL2 = 136
    INTERNATIONAL3 = 137
    INTERNATIONAL4 = 138
    INTERNATIONAL5 = 139
    INTERNATIONAL6 = 140
    INTERNATIONAL7 = 141
    INTERNATIONAL8 = 142
    INTERNATIONAL9 = 143
    LANG1 = 144
    LANG2 = 145
    LANG3 = 146
    LANG4 = 147
    LANG5 = 148
    LANG6 = 149
    LANG7 = 150
    LANG8 = 151
    LANG9 = 152

    ALTERASE = 153
    SYSREQ = 154
    CANCEL = 155
    CLEAR = 156
    PRIOR = 157
    RETURN2 = 158
    SEPARATOR = 159
    OUT = 160
    OPER = 161
    CLEARAGAIN = 162
    CRSEL = 163
    EXSEL = 164

    KP_00 = 176
    KP_000 = 177
    THOUSANDSSEPARATOR = 178
    DECIMALSEPARATOR = 179
    CURRENCYUNIT = 180
    CURRENCYSUBUNIT = 181
    KP_LEFTPAREN = 182
    KP_RIGHTPAREN = 183
    KP_LEFTBRACE = 184
    KP_RIGHTBRACE = 185
    KP_TAB = 186
    KP_BACKSPACE = 187
    KP_A = 188
    KP_B = 189
    KP_C = 190
    KP_D = 191
    KP_E = 192
    KP_F = 193
    KP_XOR = 194
    KP_POWER = 195
    KP_PERCENT = 196
    KP_LESS = 197
    KP_GREATER = 198
    KP_AMPERSAND = 199
    KP_DBLAMPERSAND = 200
    KP_VERTICALBAR = 201
    KP_DBLVERTICALBAR = 202
    KP_COLON = 203
    KP_HASH = 204
    KP_SPACE = 205
    KP_AT = 206
    KP_EXCLAM = 207
    KP_MEMSTORE = 208
    KP_MEMRECALL = 209
    KP_MEMCLEAR = 210
    KP_MEMADD = 211
    KP_MEMSUBTRACT = 212
    KP_MEMMULTIPLY = 213
    KP_MEMDIVIDE = 214
    KP_PLUSMINUS = 215
    KP_CLEAR = 216
    KP_CLEARENTRY = 217
    KP_BINARY = 218
    KP_OCTAL = 219
    KP_DECIMAL = 220
    KP_HEXADECIMAL = 221

    LCTRL = 224
    LSHIFT = 225
    LALT = 226
    LGUI = 227
    RCTRL = 228
    RSHIFT = 229
    RALT = 230
    RGUI = 231

    MODE = 257

    # Usage page 0x0C

    AUDIONEXT = 258
    AUDIOPREV = 259
    AUDIOSTOP = 260
    AUDIOPLAY = 261
    AUDIOMUTE = 262
    MEDIASELECT = 263
    WWW = 264
    MAIL = 265
    CALCULATOR = 266
    COMPUTER = 267
    AC_SEARCH = 268
    AC_HOME = 269
    AC_BACK = 270
    AC_FORWARD = 271
    AC_STOP = 272
    AC_REFRESH = 273
    AC_BOOKMARKS = 274

   # Walther keys

    BRIGHTNESSDOWN = 275
    BRIGHTNESSUP = 276
    DISPLAYSWITCH = 277
    KBDILLUMTOGGLE = 278
    KBDILLUMDOWN = 279
    KBDILLUMUP = 280
    EJECT = 281
    SLEEP = 282

    APP1 = 283
    APP2 = 284

    # Add any other keys here.

    NUM_SCANCODES = 512
  end

  enum Keycode : UInt32
    UNKNOWN = 0

    RETURN = 13 # '\r'
    ESCAPE = 27 # '\033'
    BACKSPACE = 8 # '\b'
    TAB = 9 # '\t'
    SPACE = 32 # ' '
    EXCLAIM = 33 # '!'
    QUOTEDBL = 34 # '"'
    HASH = 35 #'#'
    PERCENT = 37 # '%'
    DOLLAR = 38 # '$'
    AMPERSAND = 38 # '&'
    QUOTE = 39 # '\''
    LEFTPAREN = 40 # '('
    RIGHTPAREN = 41 # ')'
    ASTERISK = 42 # '*'
    PLUS = 43 # '+'
    COMMA = 44 # ','
    MINUS = 45 # '-'
    PERIOD = 46 # '.'
    SLASH = 47 # '/'
    KEY_0 = 48 # '0'
    KEY_1 = 49 # '1'
    KEY_2 = 50 # '2'
    KEY_3 = 51 # '3'
    KEY_4 = 52 # '4'
    KEY_5 = 53 # '5'
    KEY_6 = 54 # '6'
    KEY_7 = 55 # '7'
    KEY_8 = 56 # '8'
    KEY_9 = 57 # '9'
    COLON = 58 # ':'
    SEMICOLON = 59 # ';'
    LESS = 60 # '<'
    EQUALS = 61 # '='
    GREATER = 62 # '>'
    QUESTION = 63 # '?'
    AT = 64 # '@'

    # skip uppercase letters

    LEFTBRACKET = 91 # '['
    BACKSLASH = 92 # '\\'
    RIGHTBRACKET = 93 # ']'
    CARET = 94 # '^'
    UNDERSCORE = 95 # '_'
    BACKQUOTE = 96 # '`'
    A = 97 # 'a'
    B = 98 # 'b'
    C = 99 # 'c'
    D = 100 # 'd'
    E = 101 # 'e'
    F = 102 # 'f'
    G = 103 # 'g'
    H = 104 # 'h'
    I = 105 # 'i'
    J = 106 # 'j'
    K = 107 # 'k'
    L = 108 # 'l'
    M = 109 # 'm'
    N = 110 # 'n'
    O = 111 # 'o'
    P = 112 # 'p'
    Q = 113 # 'q'
    R = 114 # 'r'
    S = 115 # 's'
    T = 116 # 't'
    U = 117 # 'u'
    V = 118 # 'v'
    W = 119 # 'w'
    X = 120 # 'x'
    Y = 121 # 'y'
    Z = 122 # 'z'

    CAPSLOCK = Scancode::CAPSLOCK | SDLK_SCANCODE_MASK

    F1 = Scancode::F1 | SDLK_SCANCODE_MASK
    F2 = Scancode::F2 | SDLK_SCANCODE_MASK
    F3 = Scancode::F3 | SDLK_SCANCODE_MASK
    F4 = Scancode::F4 | SDLK_SCANCODE_MASK
    F5 = Scancode::F5 | SDLK_SCANCODE_MASK
    F6 = Scancode::F6 | SDLK_SCANCODE_MASK
    F7 = Scancode::F7 | SDLK_SCANCODE_MASK
    F8 = Scancode::F8 | SDLK_SCANCODE_MASK
    F9 = Scancode::F9 | SDLK_SCANCODE_MASK
    F10 = Scancode::F10 | SDLK_SCANCODE_MASK
    F11 = Scancode::F11 | SDLK_SCANCODE_MASK
    F12 = Scancode::F12 | SDLK_SCANCODE_MASK

    PRINTSCREEN = Scancode::PRINTSCREEN | SDLK_SCANCODE_MASK
    SCROLLLOCK = Scancode::SCROLLLOCK | SDLK_SCANCODE_MASK
    PAUSE = Scancode::PAUSE | SDLK_SCANCODE_MASK
    INSERT = Scancode::INSERT | SDLK_SCANCODE_MASK
    HOME = Scancode::HOME | SDLK_SCANCODE_MASK
    PAGEUP = Scancode::PAGEUP | SDLK_SCANCODE_MASK
    DELETE = 127 #'\177'
    END = Scancode::END | SDLK_SCANCODE_MASK
    PAGEDOWN = Scancode::PAGEDOWN | SDLK_SCANCODE_MASK
    RIGHT = Scancode::RIGHT | SDLK_SCANCODE_MASK
    LEFT = Scancode::LEFT | SDLK_SCANCODE_MASK
    DOWN = Scancode::DOWN | SDLK_SCANCODE_MASK
    UP = Scancode::UP | SDLK_SCANCODE_MASK

    NUMLOCKCLEAR = Scancode::NUMLOCKCLEAR | SDLK_SCANCODE_MASK
    KP_DIVIDE = Scancode::KP_DIVIDE | SDLK_SCANCODE_MASK
    KP_MULTIPLY = Scancode::KP_MULTIPLY | SDLK_SCANCODE_MASK
    KP_MINUS = Scancode::KP_MINUS | SDLK_SCANCODE_MASK
    KP_PLUS = Scancode::KP_PLUS | SDLK_SCANCODE_MASK
    KP_ENTER = Scancode::KP_ENTER | SDLK_SCANCODE_MASK
    KP_1 = Scancode::KP_1 | SDLK_SCANCODE_MASK
    KP_2 = Scancode::KP_2 | SDLK_SCANCODE_MASK
    KP_3 = Scancode::KP_3 | SDLK_SCANCODE_MASK
    KP_4 = Scancode::KP_4 | SDLK_SCANCODE_MASK
    KP_5 = Scancode::KP_5 | SDLK_SCANCODE_MASK
    KP_6 = Scancode::KP_6 | SDLK_SCANCODE_MASK
    KP_7 = Scancode::KP_7 | SDLK_SCANCODE_MASK
    KP_8 = Scancode::KP_8 | SDLK_SCANCODE_MASK
    KP_9 = Scancode::KP_9 | SDLK_SCANCODE_MASK
    KP_0 = Scancode::KP_0 | SDLK_SCANCODE_MASK
    KP_PERIOD = Scancode::KP_PERIOD | SDLK_SCANCODE_MASK

    APPLICATION = Scancode::APPLICATION | SDLK_SCANCODE_MASK
    POWER = Scancode::POWER | SDLK_SCANCODE_MASK
    KP_EQUALS = Scancode::KP_EQUALS | SDLK_SCANCODE_MASK
    F13 = Scancode::F13 | SDLK_SCANCODE_MASK
    F14 = Scancode::F14 | SDLK_SCANCODE_MASK
    F15 = Scancode::F15 | SDLK_SCANCODE_MASK
    F16 = Scancode::F16 | SDLK_SCANCODE_MASK
    F17 = Scancode::F17 | SDLK_SCANCODE_MASK
    F18 = Scancode::F18 | SDLK_SCANCODE_MASK
    F19 = Scancode::F19 | SDLK_SCANCODE_MASK
    F20 = Scancode::F20 | SDLK_SCANCODE_MASK
    F21 = Scancode::F21 | SDLK_SCANCODE_MASK
    F22 = Scancode::F22 | SDLK_SCANCODE_MASK
    F23 = Scancode::F23 | SDLK_SCANCODE_MASK
    F24 = Scancode::F24 | SDLK_SCANCODE_MASK
    EXECUTE = Scancode::EXECUTE | SDLK_SCANCODE_MASK
    HELP = Scancode::HELP | SDLK_SCANCODE_MASK
    MENU = Scancode::MENU | SDLK_SCANCODE_MASK
    SELECT = Scancode::SELECT | SDLK_SCANCODE_MASK
    STOP = Scancode::STOP | SDLK_SCANCODE_MASK
    AGAIN = Scancode::AGAIN | SDLK_SCANCODE_MASK
    UNDO = Scancode::UNDO | SDLK_SCANCODE_MASK
    CUT = Scancode::CUT | SDLK_SCANCODE_MASK
    COPY = Scancode::COPY | SDLK_SCANCODE_MASK
    PASTE = Scancode::PASTE | SDLK_SCANCODE_MASK
    FIND = Scancode::FIND | SDLK_SCANCODE_MASK
    MUTE = Scancode::MUTE | SDLK_SCANCODE_MASK
    VOLUMEUP = Scancode::VOLUMEUP | SDLK_SCANCODE_MASK
    VOLUMEDOWN = Scancode::VOLUMEDOWN | SDLK_SCANCODE_MASK
    KP_COMMA = Scancode::KP_COMMA | SDLK_SCANCODE_MASK
    KP_EQUALSAS400 = Scancode::KP_EQUALSAS400 | SDLK_SCANCODE_MASK

    ALTERASE = Scancode::ALTERASE | SDLK_SCANCODE_MASK
    SYSREQ = Scancode::SYSREQ | SDLK_SCANCODE_MASK
    CANCEL = Scancode::CANCEL | SDLK_SCANCODE_MASK
    CLEAR = Scancode::CLEAR | SDLK_SCANCODE_MASK
    PRIOR = Scancode::PRIOR | SDLK_SCANCODE_MASK
    RETURN2 = Scancode::RETURN2 | SDLK_SCANCODE_MASK
    SEPARATOR = Scancode::SEPARATOR | SDLK_SCANCODE_MASK
    OUT = Scancode::OUT | SDLK_SCANCODE_MASK
    OPER = Scancode::OPER | SDLK_SCANCODE_MASK
    CLEARAGAIN = Scancode::CLEARAGAIN | SDLK_SCANCODE_MASK
    CRSEL = Scancode::CRSEL | SDLK_SCANCODE_MASK
    EXSEL = Scancode::EXSEL | SDLK_SCANCODE_MASK

    KP_00 = Scancode::KP_00 | SDLK_SCANCODE_MASK
    KP_000 = Scancode::KP_000 | SDLK_SCANCODE_MASK
    THOUSANDSSEPARATOR = Scancode::THOUSANDSSEPARATOR | SDLK_SCANCODE_MASK
    DECIMALSEPARATOR = Scancode::DECIMALSEPARATOR | SDLK_SCANCODE_MASK
    CURRENCYUNIT = Scancode::CURRENCYUNIT | SDLK_SCANCODE_MASK
    CURRENCYSUBUNIT = Scancode::CURRENCYSUBUNIT | SDLK_SCANCODE_MASK
    KP_LEFTPAREN = Scancode::KP_LEFTPAREN | SDLK_SCANCODE_MASK
    KP_RIGHTPAREN = Scancode::KP_RIGHTPAREN | SDLK_SCANCODE_MASK
    KP_LEFTBRACE = Scancode::KP_LEFTBRACE | SDLK_SCANCODE_MASK
    KP_RIGHTBRACE = Scancode::KP_RIGHTBRACE | SDLK_SCANCODE_MASK
    KP_TAB = Scancode::KP_TAB | SDLK_SCANCODE_MASK
    KP_BACKSPACE = Scancode::KP_BACKSPACE | SDLK_SCANCODE_MASK
    KP_A = Scancode::KP_A | SDLK_SCANCODE_MASK
    KP_B = Scancode::KP_B | SDLK_SCANCODE_MASK
    KP_C = Scancode::KP_C | SDLK_SCANCODE_MASK
    KP_D = Scancode::KP_D | SDLK_SCANCODE_MASK
    KP_E = Scancode::KP_E | SDLK_SCANCODE_MASK
    KP_F = Scancode::KP_F | SDLK_SCANCODE_MASK
    KP_XOR = Scancode::KP_XOR | SDLK_SCANCODE_MASK
    KP_POWER = Scancode::KP_POWER | SDLK_SCANCODE_MASK
    KP_PERCENT = Scancode::KP_PERCENT | SDLK_SCANCODE_MASK
    KP_LESS = Scancode::KP_LESS | SDLK_SCANCODE_MASK
    KP_GREATER = Scancode::KP_GREATER | SDLK_SCANCODE_MASK
    KP_AMPERSAND = Scancode::KP_AMPERSAND | SDLK_SCANCODE_MASK
    KP_DBLAMPERSAND = Scancode::KP_DBLAMPERSAND | SDLK_SCANCODE_MASK
    KP_VERTICALBAR = Scancode::KP_VERTICALBAR | SDLK_SCANCODE_MASK
    KP_DBLVERTICALBAR = Scancode::KP_DBLVERTICALBAR | SDLK_SCANCODE_MASK
    KP_COLON = Scancode::KP_COLON | SDLK_SCANCODE_MASK
    KP_HASH = Scancode::KP_HASH | SDLK_SCANCODE_MASK
    KP_SPACE = Scancode::KP_SPACE | SDLK_SCANCODE_MASK
    KP_AT = Scancode::KP_AT | SDLK_SCANCODE_MASK
    KP_EXCLAM = Scancode::KP_EXCLAM | SDLK_SCANCODE_MASK
    KP_MEMSTORE = Scancode::KP_MEMSTORE | SDLK_SCANCODE_MASK
    KP_MEMRECALL = Scancode::KP_MEMRECALL | SDLK_SCANCODE_MASK
    KP_MEMCLEAR = Scancode::KP_MEMCLEAR | SDLK_SCANCODE_MASK
    KP_MEMADD = Scancode::KP_MEMADD | SDLK_SCANCODE_MASK
    KP_MEMSUBTRACT = Scancode::KP_MEMSUBTRACT | SDLK_SCANCODE_MASK
    KP_MEMMULTIPLY = Scancode::KP_MEMMULTIPLY | SDLK_SCANCODE_MASK
    KP_MEMDIVIDE = Scancode::KP_MEMDIVIDE | SDLK_SCANCODE_MASK
    KP_PLUSMINUS = Scancode::KP_PLUSMINUS | SDLK_SCANCODE_MASK
    KP_CLEAR = Scancode::KP_CLEAR | SDLK_SCANCODE_MASK
    KP_CLEARENTRY = Scancode::KP_CLEARENTRY | SDLK_SCANCODE_MASK
    KP_BINARY = Scancode::KP_BINARY | SDLK_SCANCODE_MASK
    KP_OCTAL = Scancode::KP_OCTAL | SDLK_SCANCODE_MASK
    KP_DECIMAL = Scancode::KP_DECIMAL | SDLK_SCANCODE_MASK
    KP_HEXADECIMAL = Scancode::KP_HEXADECIMAL | SDLK_SCANCODE_MASK

    LCTRL = Scancode::LCTRL | SDLK_SCANCODE_MASK
    LSHIFT = Scancode::LSHIFT | SDLK_SCANCODE_MASK
    LALT = Scancode::LALT | SDLK_SCANCODE_MASK
    LGUI = Scancode::LGUI | SDLK_SCANCODE_MASK
    RCTRL = Scancode::RCTRL | SDLK_SCANCODE_MASK
    RSHIFT = Scancode::RSHIFT | SDLK_SCANCODE_MASK
    RALT = Scancode::RALT | SDLK_SCANCODE_MASK
    RGUI = Scancode::RGUI | SDLK_SCANCODE_MASK

    MODE = Scancode::MODE | SDLK_SCANCODE_MASK

    AUDIONEXT = Scancode::AUDIONEXT | SDLK_SCANCODE_MASK
    AUDIOPREV = Scancode::AUDIOPREV | SDLK_SCANCODE_MASK
    AUDIOSTOP = Scancode::AUDIOSTOP | SDLK_SCANCODE_MASK
    AUDIOPLAY = Scancode::AUDIOPLAY | SDLK_SCANCODE_MASK
    AUDIOMUTE = Scancode::AUDIOMUTE | SDLK_SCANCODE_MASK
    MEDIASELECT = Scancode::MEDIASELECT | SDLK_SCANCODE_MASK
    WWW = Scancode::WWW | SDLK_SCANCODE_MASK
    MAIL = Scancode::MAIL | SDLK_SCANCODE_MASK
    CALCULATOR = Scancode::CALCULATOR | SDLK_SCANCODE_MASK
    COMPUTER = Scancode::COMPUTER | SDLK_SCANCODE_MASK
    AC_SEARCH = Scancode::AC_SEARCH | SDLK_SCANCODE_MASK
    AC_HOME = Scancode::AC_HOME | SDLK_SCANCODE_MASK
    AC_BACK = Scancode::AC_BACK | SDLK_SCANCODE_MASK
    AC_FORWARD = Scancode::AC_FORWARD | SDLK_SCANCODE_MASK
    AC_STOP = Scancode::AC_STOP | SDLK_SCANCODE_MASK
    AC_REFRESH = Scancode::AC_REFRESH | SDLK_SCANCODE_MASK
    AC_BOOKMARKS = Scancode::AC_BOOKMARKS | SDLK_SCANCODE_MASK

    BRIGHTNESSDOWN = Scancode::BRIGHTNESSDOWN | SDLK_SCANCODE_MASK
    BRIGHTNESSUP = Scancode::BRIGHTNESSUP | SDLK_SCANCODE_MASK
    DISPLAYSWITCH = Scancode::DISPLAYSWITCH | SDLK_SCANCODE_MASK
    KBDILLUMTOGGLE = Scancode::KBDILLUMTOGGLE | SDLK_SCANCODE_MASK
    KBDILLUMDOWN = Scancode::KBDILLUMDOWN | SDLK_SCANCODE_MASK
    KBDILLUMUP = Scancode::KBDILLUMUP | SDLK_SCANCODE_MASK
    EJECT = Scancode::EJECT | SDLK_SCANCODE_MASK
    SLEEP = Scancode::SLEEP | SDLK_SCANCODE_MASK
  end

  enum Keymod : UInt16
    NONE = 0x0000
    LSHIFT = 0x0001
    RSHIFT = 0x0002
    LCTRL = 0x0040
    RCTRL = 0x0080
    LALT = 0x0100
    RALT = 0x0200
    LGUI = 0x0400
    RGUI = 0x0800
    NUM = 0x1000
    CAPS = 0x2000
    MODE = 0x4000
    RESERVED = 0x8000

    CTRL  = LCTRL | RCTRL
    SHIFT = LSHIFT | RSHIFT
    ALT   = LALT | RALT
    GUI   = LGUI | RGUI
  end

  struct Keysym
    scancode : Scancode
    sym : Keycode
    mod : Keymod
    unused : UInt32
  end

  struct QuitEvent
    type : EventType
    timestamp : UInt32
  end

  enum GLattr
    GL_RED_SIZE
    GL_GREEN_SIZE
    GL_BLUE_SIZE
    GL_ALPHA_SIZE
    GL_BUFFER_SIZE
    GL_DOUBLEBUFFER
    GL_DEPTH_SIZE
    GL_STENCIL_SIZE
    GL_ACCUM_RED_SIZE
    GL_ACCUM_GREEN_SIZE
    GL_ACCUM_BLUE_SIZE
    GL_ACCUM_ALPHA_SIZE
    GL_STEREO
    GL_MULTISAMPLEBUFFERS
    GL_MULTISAMPLESAMPLES
    GL_ACCELERATED_VISUAL
    GL_RETAINED_BACKING
    GL_CONTEXT_MAJOR_VERSION
    GL_CONTEXT_MINOR_VERSION
    GL_CONTEXT_EGL
    GL_CONTEXT_FLAGS
    GL_CONTEXT_PROFILE_MASK
    GL_SHARE_WITH_CURRENT_CONTEXT
    GL_FRAMEBUFFER_SRGB_CAPABLE
  end

  # INIT_TIMER          = 0x00000001
  # INIT_AUDIO          = 0x00000010
  INIT_VIDEO          = 0x00000020
  # INIT_JOYSTICK       = 0x00000200
  # INIT_HAPTIC         = 0x00001000
  # INIT_GAMECONTROLLER = 0x00002000
  # INIT_EVENTS         = 0x00004000
  # INIT_NOPARACHUTE    = 0x00100000

  type Window = Void
  type GLContext = Void*

  WINDOW_OPENGL      = 0x00000002
  WINDOWPOS_CENTERED = 0x2FFF0000


  fun gl_getattr = SDL_GL_GetAttribute(attr: GLattr, value: Int32*) : Int32
  fun gl_setattr = SDL_GL_SetAttribute(attr: GLattr, value: Int32) : Int32
  fun gl_create_context = SDL_GL_CreateContext(window: Window*) : GLContext
  fun gl_swap_window = SDL_GL_SwapWindow(window: Window*) : Void

  fun create_window = SDL_CreateWindow(title: UInt8*, x: Int32, y: Int32, w: Int32, h: Int32, flags: UInt32) : Window*
  fun destroy_window = SDL_DestroyWindow(window: Window*) : Void

  fun delay = SDL_Delay(ms: UInt32) : Void
end

module SDL
  @@event = Pointer(LibSDL::Event).malloc
  enum Event
    None
    Quit
    Keydown
    Keyup
    TextInput
    Window
    MouseMotion
    MouseButtonUp
    MouseButtonDown

    Unknown
  end

  def self.poll_event

    event_processed = LibSDL.poll_event(@@event)
    case @@event.value.type
    when LibSDL::EventType::QUIT
      return SDL::Event::Quit, @@event.value
    when LibSDL::EventType::FIRSTEVENT
      return SDL::Event::None, @@event.value
    when LibSDL::EventType::KEYDOWN
      return SDL::Event::Keydown, @@event.value
    when LibSDL::EventType::KEYUP
      return SDL::Event::Keyup, @@event.value
    when LibSDL::EventType::TEXTINPUT
      return SDL::Event::TextInput, @@event.value
    when LibSDL::EventType::WINDOWEVENT
      return SDL::Event::Window, @@event.value
    when LibSDL::EventType::MOUSEMOTION
      return SDL::Event::MouseMotion, @@event.value
    when LibSDL::EventType::MOUSEBUTTONUP
      return SDL::Event::MouseButtonUp, @@event.value
    when LibSDL::EventType::MOUSEBUTTONDOWN
      return SDL::Event::MouseButtonDown, @@event.value
    else
      return SDL::Event::Unknown, @@event.value
    end
  end

  # Non-blocking, so if there are no events, nothing happens
  def self.next_event
    if event = self.poll_event
      yield event
    end
  end

  def self.init
    init_ret = LibSDL.init(LibSDL::INIT_VIDEO)
    if(init_ret < 0)
      puts "Failed to initialize SDL :("
      return
    end

      
    yield
    LibSDL.quit
  end

  def self.init
    LibSDL.init(LibSDL::INIT_VIDEO)
  end

  def self.quit
    LibSDL.quit
  end

  class Window
    def initialize(title : String = "",
                   x : Int = LibSDL::WINDOWPOS_CENTERED,
                   y : Int = LibSDL::WINDOWPOS_CENTERED,
                   width : Int = 640,
                   height : Int = 480,
                   flags : Int = LibSDL::WINDOW_OPENGL)

      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_CONTEXT_MAJOR_VERSION, 3)
      if err == 0
        puts "OpenGL set to major version 3"
      end
      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_CONTEXT_MINOR_VERSION, 0)
      if err == 0
        puts "OpenGL set to minor version 2"
      end
      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_DOUBLEBUFFER, 1)
      if err == 0
        puts "OpenGL set to double buffer"
      end

      window = LibSDL.create_window(title, x, y, width, height, flags)
      puts "window created"
      context = LibSDL.gl_create_context(window)
      LibGLEW.experimental = 1u8
      LibGLEW.init

      puts "about to clear color"
      # GL::ColorBuffer.clear(GL::Color4.new(0.8, 0.5, 0.3, 1.0))
      puts "about to swap buffers"
      LibSDL.gl_swap_window(window)
      # attr_val = Pointer(Int32).new
      p_attr = Pointer(Int32).malloc

      LibSDL.gl_getattr(LibSDL::GLattr::GL_CONTEXT_MAJOR_VERSION, p_attr)
      print p_attr.value
      print "."
      LibSDL.gl_getattr(LibSDL::GLattr::GL_CONTEXT_MINOR_VERSION, p_attr)
      puts p_attr.value

      print "Swap interval: "
      puts LibSDL.gl_get_swap_interval
      # LibSDL.gl_set_swap_interval(0)
      # puts LibSDL.gl_get_swap_interval
      yield(window)
      LibSDL.destroy_window(window)
      puts "window destroyed"
    end

    def initialize(title : String = "",
                   x : Int = LibSDL::WINDOWPOS_CENTERED,
                   y : Int = LibSDL::WINDOWPOS_CENTERED,
                   width : Int = 640,
                   height : Int = 480,
                   flags : Int = LibSDL::WINDOW_OPENGL)
      LibSDL.create_window(title, x, y, width, height, flags)
    end
  end

  def self.delay(ms : Int = 1000)
    LibSDL.delay(ms)
  end

end

def process_keydown_event(keysym)
  # puts keysym
  color = case keysym.sym
  when LibSDL::Keycode::R
    GL::Color4.new(1.0,0.0,0.0,1.0)
  when LibSDL::Keycode::G
    GL::Color4.new(0.0,1.0,0.0,1.0)
  when LibSDL::Keycode::B
    GL::Color4.new(0.0,0.0,1.0,1.0)
  else
    # GL::Color4.new(Random.rand, Random.rand, Random.rand, 1.0)
    GL::Color4.new(Math.sin(Time.now.ticks/1000000.0), Math.sin(Time.now.ticks/10000000.0), Math.cos(Time.now.ticks/1000000.0), 1.0)
  end
  GL::ColorBuffer.clear(color)
end

class Shader
  def initialize(name : String)
    @vert_shader_filepath = "#{__DIR__}/shaders/#{name}/shader.vert"
    @frag_shader_filepath = "#{__DIR__}/shaders/#{name}/shader.frag"
    @id = 0
    @vert_shader_handle = 0
    @frag_shader_handle = 0

  end

  def compile
    @id = LibGL.create_program
    vert_shader_source : String = File.read(@vert_shader_filepath) || ""
    @vert_shader_handle = LibGL.create_shader(LibGL::VERTEX_SHADER)
    compile_and_report_errors(vert_shader_source, @vert_shader_handle)


    frag_shader_source : String = File.read(@frag_shader_filepath) || ""
    @frag_shader_handle = LibGL.create_shader(LibGL::FRAGMENT_SHADER)
    compile_and_report_errors(frag_shader_source, @frag_shader_handle)


  end

  private def compile_and_report_errors(source : String, handle)
    p = source.to_unsafe
    LibGL.shader_source(handle, 1, pointerof(p), nil)
    LibGL.compile_shader(handle)
    LibGL.get_shader_iv(handle, LibGL::COMPILE_STATUS, out success)
    if(success == LibGL::FALSE)
        LibGL.get_shader_iv(handle, LibGL::INFO_LOG_LENGTH, out info_log_length)
        info_log = String.new(info_log_length) do |buffer|
          LibGL.get_shader_info_log(handle, info_log_length, nil, buffer)
          {info_log_length, info_log_length}
        end
        raise "Error compiling shader: #{info_log}"
    end
  end

  def bind
    LibGL.bind_attrib_location(@id, 0, "vertexPosition")
  end

  def link

    LibGL.attach_shader(@id, @vert_shader_handle)
    LibGL.attach_shader(@id, @frag_shader_handle)

    LibGL.link_program(@id)
    LibGL.get_program_iv(@id, LibGL::LINK_STATUS, out success)
    if(success == LibGL::FALSE)
      LibGL.get_program_iv(@id, LibGL::INFO_LOG_LENGTH, out info_log_length)
      info_log = String.new(info_log_length) do |buffer|
        LibGL.get_program_info_log(@id, info_log_length, nil, buffer)
        {info_log_length, info_log_length}
      end
      raise "Error linking shader: #{info_log}"
    end
  end

  def use
    puts @id
    gets
    LibGL.use_program(@id)
    puts "hi"
  end

end
SDL.init do

  puts "sdl is running"

  SDL::Window.new(title: "test title here", width: 1024, height: 768) do |window|
    running = true

    triangle = [
      -1_f32, -1_f32,
       1_f32, -1_f32,
       0_f32,  1_f32
    ]


    #load shader source strings

    #create shader programs
    shader = Shader.new("simple")
    shader.compile
    shader.bind
    shader.link
    shader.use
    puts "1"

    #compile shader programs
    # LibGL.clear_depth(1.0)
    # puts "1"
    # LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
    # puts "1"
    # LibSDL.gl_swap_window(window)
    puts "1"
    # LibGL.gen_vertex_arrays(1, out voa_handle)

    # Create a VBO and receive a handle
    LibGL.gen_buffers(1, out vbo_handle)
    puts "1"
    # LibGL.bind_vertex_array(voa_handle)

    # Bind the Array Buffer to our buffer using the handle
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, vbo_handle)
    puts "1"

      # Pipe data over to VRAM
    puts triangle.size * sizeof(LibGL::FLOAT)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, 24, triangle.to_unsafe.as(Void*), LibGL::STATIC_DRAW)
    puts "2"

      # Only use the position attribute of our vertices
      LibGL.enable_vertex_attrib_array(0_u32)
    puts "2"

        # Refer to the starting point of drawable data
        LibGL.vertex_attrib_pointer(0_u32, 2, LibGL::FLOAT, LibGL::FALSE, 0, nil)
    puts "2"

        # What sort of thing to draw, where to start in the buffer, and how many vertices
        puts LibGL::TRIANGLES
        LibGL.draw_arrays(LibGL::TRIANGLES, 0_u32, 3)
    puts "2"

      # Disable position attribute use
      LibGL.disable_vertex_attrib_array(0_u32)
    puts "2"

    # Unbind the Array Buffer
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, 0_u32)
    puts "2"
    puts "entering loop"
    while running
      time = Time.now
      
      swapped = false
      SDL.next_event do |event_type, event|
        case event_type
        when SDL::Event::Quit
          running = false
        when SDL::Event::Keydown
          LibSDL.gl_swap_window(window)
          # process_keydown_event(event.key.keysym)
          swapped = true
        when SDL::Event::Keyup

        when SDL::Event::TextInput
        when SDL::Event::None
        when SDL::Event::Window
          # puts event
        when SDL::Event::MouseMotion
        when SDL::Event::MouseButtonUp
        when SDL::Event::MouseButtonDown
        else
          puts event
        end
      end
      if swapped
        t = Time.now - time
        # if t.ticks > 3000
          print "%.3f" % (t.ticks / 10000.0)
          puts " ms"
        # end
      end

    end
  end

end


puts "sdl stopped"

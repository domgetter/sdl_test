require "./sdl_test/*"
require "./glm"

module Crystal::System::Time

  def self.monotonic : {Int64, Int32}
    if LibC.QueryPerformanceCounter(out ticks) == 0
      raise WinError.new("QueryPerformanceCounter")
    end

    {ticks / @@performance_frequency, (ticks.remainder(@@performance_frequency) * NANOSECONDS_PER_SECOND / @@performance_frequency).to_i32}
  end

end

lib LibGC
  fun get_bytes_since_gc = GC_get_bytes_since_gc() : LibC::SizeT
end

struct StaticArray(T, N)
  def buffer
    @buffer
  end
end

@[Link("OpenGL32")]
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
  CW                 = 0x00000900_u32
  CCW                = 0x00000901_u32
  FRONT              = 0x00000404_u32
  BACK               = 0x00000405_u32
  DEPTH_TEST         = 0x00000B71_u32
  CULL_FACE          = 0x00000B44_u32
  MULTISAMPLE        = 0x0000809D_u32
  FLOAT = 0x00001406_u32
  FALSE = 0_u8
  TRIANGLES = 0x00000004_u32

  fun clear_color = glClearColor(red: Float, green: Float, blue: Float, alpha: Float) : Void
  fun clear_depth = glClearDepth(depth : Double) : Void
  fun clear = glClear(mask: Bitfield) : Void
  fun enable_client_state = glEnableClientState(cap : Enum) : Void
  fun disable_client_state = glDisableClientState(cap : Enum) : Void
  fun gen_vertex_arrays = glGenVertexArrays(n : SizeI, ids : UInt*) : Void
  fun bind_vertex_array = glBindVertexArray(id : UInt) : Void
  fun draw_arrays = glDrawArrays(mode : Enum, first : Int, count : SizeI) : Void
  fun flush = glFlush() : Void
  fun finish = glFinish() : Void
  fun enable = glEnable(cap : Enum) : Void
  fun get_error = glGetError() : Enum
  fun front_face = glFrontFace(mode : Enum) : Void
  fun cull_face = glCullFace(mode : Enum) : Void
  fun enable = glEnable(cap : Enum) : Void
  fun uniform1f = glUniform1f(location : Int, v0 : Float) : Void
  alias CreateProgram            =                                        -> UInt
  alias CreateShader             =                                   Enum -> UInt
  alias CompileShader            =                                   UInt -> Void
  alias LinkProgram              =                                   UInt -> Void
  alias UseProgram               =                                   UInt -> Void
  alias DisableVertexAttribArray =                                   UInt -> Void
  alias EnableVertexAttribArray  =                                   UInt -> Void
  alias Uniform1f                =                             Int, Float -> Void
  alias BindBuffer               =                             Enum, UInt -> Void
  alias AttachShader             =                             UInt, UInt -> Void
  alias GetUniformLocation       =                            UInt, Char* -> Int
  alias GetAttribLocation        =                            UInt, Char* -> Int
  alias GenBuffers               =                           SizeI, UInt* -> Void
  alias GetShaderIV              =                       UInt, Enum, Int* -> Void
  alias GetProgramIV             =                       UInt, Enum, Int* -> Void
  alias BindAttribLocation       =                      UInt, UInt, Char* -> Void
  alias ShaderSource             =              UInt, SizeI, Char**, Int* -> Void
  alias GetShaderInfoLog         =             UInt, SizeI, SizeI*, Char* -> Void
  alias GetProgramInfoLog        =             UInt, SizeI, SizeI*, Char* -> Void
  alias UniformMatrix4fv         =            Int, SizeI, Boolean, Float* -> Void
  alias BufferData               =            Enum, SizeIPtr, Void*, Enum -> Void
  alias VertexAttribPointer      = UInt, Int, Enum, Boolean, SizeI, Void* -> Void
  fun get_proc_address = wglGetProcAddress(arg1 : Char*) : (->)

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

@[Link("glew32s")]
lib LibGLEW

  OK = 0
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

  $experimental = glewExperimental : LibGL::Boolean

  fun init = glewInit() : Int32
  # unresolved
  # fun get_uniform_location = glGetUniformLocation(program : UInt32, name : UInt8*) : Int32
  # fun get_uniform_location = LibGL.get_proc_address("glGetUniformLocation")
  # fun get_uniform_location
  # def self.get_uniform_location(program : UInt32, name : UInt8*) : Int32
  #   LibGL.get_proc_address("glGetUniformLocation").call(program, name)
  # end
  # fun gen_buffers = glGenBuffers(n : SizeI, ids : UInt*) : Void
  # fun bind_buffer = glBindBuffer(target : Enum, id : UInt) : Void
  # fun buffer_data = glBufferData(target : Enum, size : SizeIPtr, data : Void*, usage : Enum) : Void
  # fun enable_vertex_attrib_array = glEnableVertexAttribArray(index : UInt) : Void
  # fun vertex_attrib_pointer = glVertexAttribPointer(index : UInt, size : Int, type : Enum, normalized : Boolean, stride : SizeI, pointer : Void*) : Void
  # fun disable_vertex_attrib_array = glDisableVertexAttribArray(index : UInt) : Void
  # fun uniform_matrix_4fv = glUniformMatrix4fv(location : Int, count : SizeI, transpose : Boolean, value : Float*) : Void
  # fun create_program = glCreateProgram() : UInt
  # fun create_shader = glCreateShader(shaderType : Enum) : UInt
  # # fun shader_source = glShaderSource(shader : UInt, count : SizeI, string : Char**, length : Int*) : Void
  # fun compile_shader = glCompileShader(shader : UInt) : Void
  # fun get_shader_iv = glGetShaderiv(shader : UInt, pname : Enum, params : Int*) : Void
  # fun get_shader_info_log = glGetShaderInfoLog(shader : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  # fun bind_attrib_location = glBindAttribLocation(program : UInt, index : UInt, name : Char*) : Void
  # fun attach_shader = glAttachShader(program : UInt, shader : UInt) : Void
  # fun link_program = glLinkProgram(program : UInt) : Void
  # fun get_program_iv = glGetProgramiv(program : UInt, pname : Enum, params : Int*) : Void
  # fun get_program_info_log = glGetProgramInfoLog(program : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  # fun use_program = glUseProgram(program : UInt) : Void

end

@[Link("sdl2_image")]
lib LibSDLImage

end

@[Link("sdl2")]
lib LibSDL

  fun init = SDL_Init(flags: UInt32) : Int32
  fun quit = SDL_Quit() : Void
  fun poll_event = SDL_PollEvent(event : Event*) : Int32
  fun get_error = SDL_GetError() : Char*
  fun gl_get_swap_interval = SDL_GL_GetSwapInterval() : Int32
  fun gl_set_swap_interval = SDL_GL_SetSwapInterval(interval : Int32) : Int32
  fun set_relative_mouse_mode = SDL_SetRelativeMouseMode(enabled : Bool) : Void

  # struct Surface
  #   flags : UInt32
  #   format : PixelFormat
  #   w : Int
  #   h : Int
  #   pixels : Void*
  #   userdata : Void*
  #   locked : Int
  #   lock_data : Void*
  #   clip_rect : Rect
  #   map : Void*
  #   refcount : Int
  # end

  struct DisplayMode
    format : UInt32
    w : Int32
    h : Int32
    refresh_rate : Int32
    driverdata : Void*
  end

  fun get_window_display_mode = SDL_GetWindowDisplayMode(window : Window*, mode : DisplayMode*) : Int32

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
    motion : MouseMotionEvent
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

  struct MouseMotionEvent
    type : EventType
    timestamp : UInt32
    windowID : UInt32
    which : UInt32
    state : UInt32
    x : Int32
    y : Int32
    xrel : Int32
    yrel : Int32
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

  WINDOW_FULLSCREEN  = 0x00000001
  WINDOW_OPENGL      = 0x00000002
  WINDOW_BORDERLESS  = 0x00000010
  WINDOW_FULLSCREEN_DESKTOP  = 0x00001001
  WINDOW_ALLOW_HIGHDPI = 0x00002000
  WINDOWPOS_CENTERED = 0x2FFF0000

  fun gl_getattr = SDL_GL_GetAttribute(attr: GLattr, value: Int32*) : Int32
  fun gl_setattr = SDL_GL_SetAttribute(attr: GLattr, value: Int32) : Int32
  fun gl_create_context = SDL_GL_CreateContext(window: Window*) : GLContext
  fun gl_swap_window = SDL_GL_SwapWindow(window: Window*) : Void
  fun create_window = SDL_CreateWindow(title: UInt8*, x: Int32, y: Int32, w: Int32, h: Int32, flags: UInt32) : Window*
  fun destroy_window = SDL_DestroyWindow(window: Window*) : Void
  fun get_display_dpi = SDL_GetDisplayDPI(index: Int32, diagonal: Float32*, horizontal: Float32*, vertical: Float32*) : Int32
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
    event_processed : Int32 = 0

    # count = 0
    # last_count = count
    # while true
      poll_event_time = Time.measure do
        event_processed = LibSDL.poll_event(@@event)
      end
    #   if poll_event_time.total_milliseconds > 10
    #     puts count - last_count
    #     puts poll_event_time.total_milliseconds
    #     last_count = count
    #   end
    #   sleep 0.01
    #   count += 1
    # end

    # print "poll_event time: "
    # puts poll_event_time.total_nanoseconds/1000.0

    if event_processed == 0
      return nil
    end
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
    while event = self.poll_event
      yield event
    end
  end

  def self.init
    init_ret = LibSDL.init(LibSDL::INIT_VIDEO)
    if(init_ret < 0)
      puts "Failed to initialize SDL :("
      puts init_ret
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

    # initialize with block
    def initialize(title : String = "",
                   x : Int = LibSDL::WINDOWPOS_CENTERED,
                   y : Int = LibSDL::WINDOWPOS_CENTERED,
                   width : Int = 640,
                   height : Int = 480,
                   flags : Int = LibSDL::WINDOW_OPENGL)

      # p_attr = uninitialized Pointer(Int32)
      attr = 0_32
      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_CONTEXT_MAJOR_VERSION, 3)
      raise "Could not set GL_CONTEXT_MAJOR_VERSION\n SDL error: #{err}" if err != 0

      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_CONTEXT_MINOR_VERSION, 0)
      raise "Could not set GL_CONTEXT_MINOR_VERSION\n SDL error: #{err}" if err != 0

      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_DOUBLEBUFFER, 1)
      raise "Could not set GL_DOUBLEBUFFER\n SDL error: #{err}" if err != 0

      # Enable antialiasing
      err = LibSDL.gl_setattr(LibSDL::GLattr::GL_MULTISAMPLEBUFFERS, 1)
      raise "Could not set GL_MULTISAMPLEBUFFERS\n SDL error: #{err}" if err != 0

      LibSDL.gl_setattr(LibSDL::GLattr::GL_MULTISAMPLESAMPLES, 8)
      LibSDL.gl_setattr(LibSDL::GLattr::GL_ACCELERATED_VISUAL, 1)

      LibSDL.get_display_dpi(1, out diag_dpi, vertical: out vert_dpi, horizontal: out horiz_dpi)
      width = (width/(horiz_dpi/96.0)).floor
      height = (height/(vert_dpi/96.0)).floor
      window = LibSDL.create_window(title, x, y, width, height, flags)
      context = LibSDL.gl_create_context(window)
      LibGLEW.experimental = 1u8
      LibGLEW.init
      LibSDL.gl_set_swap_interval(1)

      LibSDL.gl_getattr(LibSDL::GLattr::GL_DOUBLEBUFFER, pointerof(attr))
      puts "Double buffer is set to : #{attr}"

      LibSDL.gl_getattr(LibSDL::GLattr::GL_MULTISAMPLEBUFFERS, pointerof(attr))
      puts "Multisample Buffers is set to : #{attr}"

      LibSDL.gl_getattr(LibSDL::GLattr::GL_MULTISAMPLESAMPLES, pointerof(attr))
      puts "Multisample Samples is set to : #{attr}"

      LibGL.front_face(LibGL::CW)
      LibGL.cull_face(LibGL::BACK)
      LibGL.enable(LibGL::CULL_FACE)
      LibGL.enable(LibGL::MULTISAMPLE)
      LibGL.enable(LibGL::DEPTH_TEST)

      LibSDL.gl_swap_window(window)

      LibSDL.gl_getattr(LibSDL::GLattr::GL_CONTEXT_MAJOR_VERSION, pointerof(attr))
      print attr
      print "."
      LibSDL.gl_getattr(LibSDL::GLattr::GL_CONTEXT_MINOR_VERSION, pointerof(attr))
      puts attr

      vsync = LibSDL.gl_get_swap_interval
      puts "Vsync is #{vsync == 0 ? "off" : "on"}"

      LibSDL.get_window_display_mode(window, out mode)
      puts "Refresh rate: #{mode.refresh_rate}Hz"

      yield(window)

      LibSDL.destroy_window(window)
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

class ShaderProgram

  getter :id
  @id : LibGL::UInt
  @vert_shader_handle : LibGL::UInt
  @frag_shader_handle : LibGL::UInt

  def initialize(name : String)
    @vert_shader_filepath = "./shaders/#{name}/shader.vert"
    @frag_shader_filepath = "./shaders/#{name}/shader.frag"
    @id = 0
    @vert_shader_handle = 0
    @frag_shader_handle = 0

  end

  def compile
    @id = GL.create_program.call()
    # @id = LibGLEW.create_program()

    vert_shader_source : String = File.read(@vert_shader_filepath) || ""
    @vert_shader_handle = GL.create_shader.call(LibGL::VERTEX_SHADER)
    if @vert_shader_handle == 0
      raise "couldn't create vertex shader"
    end
    compile_and_report_errors(vert_shader_source, @vert_shader_handle)

    frag_shader_source : String = File.read(@frag_shader_filepath) || ""
    @frag_shader_handle = GL.create_shader.call(LibGL::FRAGMENT_SHADER)
    if @frag_shader_handle == 0
      raise "couldn't create fragment shader"
    end
    compile_and_report_errors(frag_shader_source, @frag_shader_handle)

  end

  private def compile_and_report_errors(source : String, handle)
    p = source.to_unsafe
    q = source.size
    GL.shader_source.call(handle, 1, pointerof(p), pointerof(q))
    GL.compile_shader.call(handle)
    success = uninitialized LibGL::Int
    GL.get_shader_iv.call(handle, LibGL::COMPILE_STATUS, pointerof(success))

    if(success == LibGL::FALSE)
      info_log_length = uninitialized LibGL::SizeI
      GL.get_shader_iv.call(handle, LibGL::INFO_LOG_LENGTH, pointerof(info_log_length))
      info_log = String.new(info_log_length) do |buffer|
        r = uninitialized LibGL::SizeI
        GL.get_shader_info_log.call(handle, info_log_length, pointerof(r), buffer)
        {info_log_length, info_log_length}
      end
      raise "Error compiling shader: #{info_log}\nhandle: #{handle}"
    end
  end

  def link

    GL.attach_shader.call(@id, @vert_shader_handle)
    GL.attach_shader.call(@id, @frag_shader_handle)

    GL.link_program.call(@id)
    success = uninitialized LibGL::Int
    GL.get_program_iv.call(@id, LibGL::LINK_STATUS, pointerof(success))
    if(success == LibGL::FALSE)
      info_log_length = uninitialized LibGL::SizeI
      GL.get_program_iv.call(@id, LibGL::INFO_LOG_LENGTH, pointerof(info_log_length))
      info_log = String.new(info_log_length) do |buffer|
        r = uninitialized LibGL::SizeI*
          GL.get_program_info_log.call(@id, info_log_length, r, buffer)
        {info_log_length, info_log_length}
      end
      raise "Error linking shader: #{info_log}"
    end
  end

  def use
    print "in program.use.  id: "
    puts @id
    GL.use_program(@id)
  end

  def use
    GL.use_program(@id)
    # time = Time.measure do
      yield
    # end
    # time_us = time.total_nanoseconds/1000.0
    # print "\u001B[32m"
    # if time_us > 20
    #   print "\u001B[33m"
    # end
    # if time_us > 100
    #   print "\u001B[31m"
    # end
    # print "program "
    # print @id
    # print " took "
    # print time.total_nanoseconds/1000.0
    # puts "us"
    # if time_us > 20
    #   print "\u001B[0m"
    # end
    GL.use_program(0_u32)
  end

  def unuse
    GL.use_program(0_u32)
  end

end

def mvp_static(
          position : GLM::Vec3Static,
             model : GLM::Mat4Static,
            buffer : StaticArray(Float32, 16),
  horizontal_angle : Float32 = 3.14_f32,
    vertical_angle : Float32 = 0.0_f32)

  direction = GLM.vec3_static(
    Math.cos(vertical_angle) * Math.sin(horizontal_angle),
    Math.sin(vertical_angle),
    Math.cos(vertical_angle) * Math.cos(horizontal_angle)
  )
  right = GLM.vec3_static(
    Math.sin(horizontal_angle - (Math::PI / 2)),
    0,
    Math.cos(horizontal_angle - (Math::PI / 2))
  )
  right.cross(direction)

  perspective = GLM.perspective_static(70.0, (4.0/3.0), 0.1, 100.0, buffer)
  direction + position

  view = GLM.look_at_static(position, direction, right)

  return (perspective * view * model)

end

def mvp(horizontal_angle : Float32 = 3.14_f32,
        vertical_angle : Float32 = 0.0_f32,
        position : GLM::Vec3 = GLM.vec3(0, 0, 5),
        model : GLM::Mat4 = GLM::Mat4.identity)

  direction = GLM.vec3(
    Math.cos(vertical_angle) * Math.sin(horizontal_angle),
    Math.sin(vertical_angle),
    Math.cos(vertical_angle) * Math.cos(horizontal_angle)
  )
  right = GLM.vec3(
    Math.sin(horizontal_angle - (Math::PI / 2)),
    0,
    Math.cos(horizontal_angle - (Math::PI / 2))
  )
  # puts direction.to_s
  # puts right.to_s
  up = right.cross(direction)
  perspective = GLM.perspective(70.0, (4.0/3.0), 0.1, 100.0)
  # puts perspective.buffer
  # puts perspective.to_s

  direction = direction + position
  view = GLM.look_at(position, direction, up)
  # puts "====----===="
  # puts perspective.to_s
  # puts view.to_s
  # puts model.to_s

  return (perspective * view * model)

end

module GL

  def self.get_uniform_location
    Box(LibGL::GetUniformLocation)
      .unbox(Box.box(LibGL.get_proc_address("glGetUniformLocation")))
  end

  def self.gen_buffers
    Box(LibGL::GenBuffers)
      .unbox(Box.box(LibGL.get_proc_address("glGenBuffers")))
  end

  def self.bind_buffer
    Box(LibGL::BindBuffer)
      .unbox(Box.box(LibGL.get_proc_address("glBindBuffer")))
  end

  def self.buffer_data(
    data : Void*,
    size : LibGL::SizeIPtr,
    target : LibGL::Enum = LibGL::ARRAY_BUFFER,
    usage : LibGL::Enum = LibGL::STATIC_DRAW
  )
    Box(LibGL::BufferData)
      .unbox(Box.box(LibGL.get_proc_address("glBufferData")))
      .call(target, size, data, usage)
  end

  def self.enable_vertex_attrib_array 
    Box(LibGL::EnableVertexAttribArray)
      .unbox(Box.box(LibGL.get_proc_address("glEnableVertexAttribArray")))
  end

  def self.vertex_attrib_pointer(
    offset : Void* = Pointer(Void).new(0),
    attribute : LibGL::UInt = 0_u32,
    dimension : LibGL::Int = 3,
    type : LibGL::Enum = LibGL::FLOAT,
    normalized = LibGL::FALSE,
    stride = 0)
    Box(LibGL::VertexAttribPointer)
      .unbox(Box.box(LibGL.get_proc_address("glVertexAttribPointer"))).call(attribute, dimension, type, normalized, stride, offset)
  end

  def self.disable_vertex_attrib_array 
    Box(LibGL::DisableVertexAttribArray)
      .unbox(Box.box(LibGL.get_proc_address("glDisableVertexAttribArray")))
  end

  def self.uniform_matrix_4fv(a : LibGL::Int, b : LibGL::SizeI, c : LibGL::Boolean, d : LibGL::Float*) 
    (@@uniform_matrix_4fv_function ||= Box(LibGL::UniformMatrix4fv).unbox(Box.box(LibGL.get_proc_address("glUniformMatrix4fv"))))
      .call(a, b, c, d)
  end


  def self.uniform1f(location : Int32, value : Float32)
    (@@uniform1f_function ||= Box(LibGL::Uniform1f).unbox(Box.box(LibGL.get_proc_address("glUniform1f"))))
      .call(location, value)
  end

  def self.create_program
    Box(LibGL::CreateProgram)
      .unbox(Box.box(LibGL.get_proc_address("glCreateProgram")))
  end

  # fun create_shader = glCreateShader(shaderType : Enum) : UInt
  def self.create_shader 
    Box(LibGL::CreateShader)
      .unbox(Box.box(LibGL.get_proc_address("glCreateShader")))
  end

  def self.shader_source 
    Box(LibGL::ShaderSource)
      .unbox(Box.box(LibGL.get_proc_address("glShaderSource")))
  end

  def self.compile_shader 
    Box(LibGL::CompileShader)
      .unbox(Box.box(LibGL.get_proc_address("glCompileShader")))
  end

  # # fun get_shader_iv = glGetShaderiv(shader : UInt, pname : Enum, params : Int*) : Void
  def self.get_shader_iv 
    Box(LibGL::GetShaderIV)
      .unbox(Box.box(LibGL.get_proc_address("glGetShaderiv")))
  end

  # # fun get_shader_info_log = glGetShaderInfoLog(shader : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  def self.get_shader_info_log 
    Box(LibGL::GetShaderInfoLog)
      .unbox(Box.box(LibGL.get_proc_address("glGetShaderInfoLog")))
  end

  # # fun bind_attrib_location = glBindAttribLocation(program : UInt, index : UInt, name : Char*) : Void
  def self.bind_attrib_location 
    Box(LibGL::BindAttribLocation)
      .unbox(Box.box(LibGL.get_proc_address("glBindAttribLocation")))
  end

  # # fun get_attrib_location = glBindAttribLocation(program : UInt, name : Char*) : Void
  def self.get_attrib_location 
    Box(LibGL::GetAttribLocation)
      .unbox(Box.box(LibGL.get_proc_address("glGetAttribLocation")))
  end

  # # fun attach_shader = glAttachShader(program : UInt, shader : UInt) : Void
  def self.attach_shader 
    Box(LibGL::AttachShader)
      .unbox(Box.box(LibGL.get_proc_address("glAttachShader")))
  end

  # # fun link_program = glLinkProgram(program : UInt) : Void
  def self.link_program 
    Box(LibGL::LinkProgram)
      .unbox(Box.box(LibGL.get_proc_address("glLinkProgram")))
  end

  # # fun get_program_iv = glGetProgramiv(program : UInt, pname : Enum, params : Int*) : Void
  def self.get_program_iv 
    Box(LibGL::GetProgramIV)
      .unbox(Box.box(LibGL.get_proc_address("glGetProgramiv")))
  end

  # # fun get_program_info_log = glGetProgramInfoLog(program : UInt, buf_size : SizeI, length : SizeI*, info_log : Char*) : Void
  def self.get_program_info_log
    Box(LibGL::GetProgramInfoLog)
      .unbox(Box.box(LibGL.get_proc_address("glGetProgramInfoLog")))
  end

  # # fun use_program = glUseProgram(program : UInt) : Void
  def self.use_program(id : LibGL::UInt) 
    (@@use_program_function ||= Box(LibGL::UseProgram).unbox(Box.box(LibGL.get_proc_address("glUseProgram"))))
      .call(id)
  end

  def self.draw_triangles(triangles)
    LibGL.draw_arrays(LibGL::TRIANGLES, 0_u32, triangles.size/3)
  end

end

alias Coord3D = Tuple(Float32, Float32, Float32)
alias Triangle = Tuple(Coord3D, Coord3D, Coord3D)


# in an ECS, the manager runs the systems on relevant entities
# whereas in OOP, the 'entities' are the source of behavior
#  e.g. player.draw vs RenderSystem.render(renderables)

# Component
module Component
  # module Renderable

  #   def render
  #     @shader.use do

  #       # GL.draw_array(...)
  #     end
  #   end
  # end

  class Transform
    @transform : StaticArray(Float32, 3)
    def initialize(x : Float32, y : Float32, z : Float32)
      @transform = Float32.static_array(x, y, z)
    end
    def to_s
      @transform.to_s
    end

    def x
      @transform[0]
    end
    def y
      @transform[1]
    end
    def z
      @transform[2]
    end
    def x=(v : Float32)
      @transform[0] = v
    end
    def y=(v : Float32)
      @transform[1] = v
    end
    def z=(v : Float32)
      @transform[2] = v
    end
  end

  # module Physics
  #   def update

  #   end
  # end
end


class Entity

  def initialize(x : Float32 = 0, y : Float32 = 0, z : Float32 = 0)
    @transform = Component::Transform.new(x, y, z)
  end

  def transform
    @transform
  end
  # include Component::Transform
end

# Entity
class Player < Entity
  # include Component::Renderable
  # def add_component(name)
    # self.instance_variable_set(name.to_sym, 
end

# class Tetra < Entity
#   # Should component lists be static or dynamic?
#   # Can modules be added at runtime to a class? No
#   # Should components be modules?
#   # I don't think so, because modules can only be added at compile time.
#   # If components are named state, how do we add them to entities?
#   #   A) set instance variables.  player.
  
#   include Component::Renderable
#   # def add_comp(component)
#   #   include component
#   # end
# end

# System
module System
  # module Render
  #   def render
  #     LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)
  #     @@entities.filter {|e| e.hasComponent(Renderable)}.each(&.render)
  #     LibSDL.gl_swap_window(window)
  #   end
  # end

  # module Physics
  #   def update(entities)
  #     physical_entities = entities.filter {|entity| entity.has_component?(Physics)}
  #     physical_entities.each(&.update)
  #   end
  # end
end

player = Player.new
puts player.transform.to_s
t = player.transform
t.x = 3
puts player
puts player.transform.to_s
player.transform.y = 5
puts player.transform.to_s

# SystemA  SystemB

# CompA      CompB
# 1           1
# 2           
#             3
# 4           4
# 5
#             6
# 7           7
# 8           8
# 9           9
# 10

# 1, 2, 4, 5, 7, 8, 9, 10
#             1, 3, 4, 6, 7, 8, 9
#             1, 3, 4, 7, 8, 9

NUM_BUFFERS = 2
SDL.init do

  SDL::Window.new(title: "Crystal OpenGL Demo", width: 1920*2, height: 1080*2,
                  flags: LibSDL::WINDOW_OPENGL | LibSDL::WINDOW_FULLSCREEN_DESKTOP ) do |window|
  # SDL::Window.new(title: "Crystal OpenGL Demo", width: 1920/5, height: 1080/5, x: 50, y: 50,
  #                 flags: LibSDL::WINDOW_OPENGL | LibSDL::WINDOW_BORDERLESS) do |window|
    running = true
    position_attribute = uninitialized LibGL::Int

    # data for shapes
    a = [ -1_f32,  1_f32, -1_f32 ]
    b = [ -1_f32,  -1_f32, 1_f32 ]
    c = [ 1_f32,  1_f32, 1_f32 ]
    d = [ 1_f32,  -1_f32, -1_f32 ]
    a1 = [ 1_f32,  1_f32, -1_f32 ]
    b1 = [ 1_f32,  -1_f32, 1_f32 ]
    c1 = [ 3_f32,  1_f32, 1_f32 ]
    d1 = [ 3_f32,  -1_f32, -1_f32 ]
    a2 = [ 5_f32,  1_f32, -1_f32 ]
    b2 = [ 5_f32,  -1_f32, 1_f32 ]
    c2 = [ 7_f32,  1_f32, 1_f32 ]
    d2 = [ 7_f32,  -1_f32, -1_f32 ]
    a3 = [ 3_f32,  1_f32, -1_f32 ]
    b3 = [ 3_f32,  -1_f32, 1_f32 ]
    c3 = [ 5_f32,  1_f32, 1_f32 ]
    d3 = [ 5_f32,  -1_f32, -1_f32 ]

    cube1 = [0_f32, 0_f32, 5_f32]
    cube2 = [1_f32, 0_f32, 5_f32]
    cube3 = [0_f32, 0_f32, 6_f32]
    cube4 = [1_f32, 0_f32, 6_f32]
    cube5 = [0_f32, 1_f32, 5_f32]
    cube6 = [1_f32, 1_f32, 5_f32]
    cube7 = [0_f32, 1_f32, 6_f32]
    cube8 = [1_f32, 1_f32, 6_f32]

    octo1 = [0_f32, -2_f32, 5.5_f32]
    octo2 = [1_f32, -2_f32, 5.5_f32]
    octo3 = [0_f32, -1_f32, 5.5_f32]
    octo4 = [1_f32, -1_f32, 5.5_f32]
    octo5 = [0.5_f32, -1.5_f32, 5.5_f32 + Math.sqrt(2)/2.0]
    octo6 = [0.5_f32, -1.5_f32, 5.5_f32 - Math.sqrt(2)/2.0]

    triangle = [
      # cube1, cube3, cube4,
      # cube4, cube2, cube1,
      # cube2, cube4, cube8,
      # cube8, cube6, cube2,
      # cube4, cube3, cube7,
      # cube7, cube8, cube4,
      # cube1, cube2, cube5,
      # cube5, cube2, cube6,
      # cube8, cube5, cube6,
      # cube8, cube7, cube5,
      # cube7, cube3, cube1,
      # cube1, cube5, cube7,

      # octo1, octo5, octo2,
      # octo3, octo5, octo1,
      # octo4, octo5, octo3,
      # octo2, octo5, octo4,
      # octo2, octo6, octo1,
      # octo1, octo6, octo3,
      # octo3, octo6, octo4,
      # octo4, octo6, octo2,


      a, c, b,
      b, d, a,
      c, d, b,
      d, c, a
      # a1, c1, b1,
      # a1, b1, d1,
      # b1, c1, d1,
      # c1, a1, d1,
      # a2, c2, b2,
      # a2, b2, d2,
      # b2, c2, d2,
      # c2, a2, d2,
      # a3, c3, b3,
      # a3, b3, d3,
      # b3, c3, d3,
      # c3, a3, d3
    ].flatten

    normals = [
      a, b, c, d
      # a, c, b,
      # a, b, d,
      # b, c, d,
      # c, a, d
    ]

    #create shader programs
    program = ShaderProgram.new("simple")
    program.compile
    program.link
    model : GLM::Mat4Static
    rotation : GLM::Mat4Static
    transform : GLM::Mat4Static
    position : GLM::Vec3Static

    loc3 = GL.get_uniform_location.call(program.id, "transform".to_unsafe)
    loc2 = GL.get_uniform_location.call(program.id, "rotation".to_unsafe)
    loc1 = GL.get_uniform_location.call(program.id, "time".to_unsafe)
    print "time uniform id: "
    puts loc1
    raise "Unable to retrieve location of uniform 'time'" if loc3 < 0
    print "transform uniform id: "
    puts loc3
    raise "Unable to retrieve location of uniform 'transform'" if loc3 < 0
    print "rotation uniform id : "
    puts loc2
    raise "Unable to retrieve location of uniform 'rotation'" if loc2 < 0
    puts program
    puts triangle[0..5].to_s + "..."

    # Create a VBO and receive a handle
    buffers = uninitialized LibGL::UInt[NUM_BUFFERS]
    GL.gen_buffers.call(NUM_BUFFERS, buffers.to_unsafe)

    # Bind the Array Buffer to our buffer using the handle
    # Another way to think of it, "register" our new buffer to THE array buffer
    GL.bind_buffer.call(LibGL::ARRAY_BUFFER, buffers[0])

    # Pipe data over to VRAM
    GL.buffer_data(size: triangle.size * sizeof(LibGL::FLOAT),
                   data: triangle.to_unsafe.as(Void*))

    # Only use the position attribute of our vertices
    position_attribute = GL.get_attrib_location.call(program.id, "vertPosition".to_unsafe)
    raise "Unable to retrieve position attribute location" if position_attribute < 0
    normal_attribute = GL.get_attrib_location.call(program.id, "vertNormal".to_unsafe)
    raise "Unable to retrieve normal attribute location" if normal_attribute < 0
    normal2_attribute = GL.get_attrib_location.call(program.id, "vertNormal2".to_unsafe)
    raise "Unable to retrieve normal2 attribute location" if normal2_attribute < 0

    puts "position attribute location: #{position_attribute}"
    puts "normal attribute location: #{normal_attribute}"
    puts "normal2 attribute location: #{normal2_attribute}"
    # gets
    GL.enable_vertex_attrib_array.call(position_attribute.to_u32)

    # Refer to the starting point of drawable data
    GL.vertex_attrib_pointer(attribute: position_attribute.to_u32)

    # Bind the normals buffer using the handle
    GL.bind_buffer.call(LibGL::ARRAY_BUFFER, buffers[1])

    # Pipe normals data over to VRAM
    GL.buffer_data(size: normals.size * sizeof(LibGL::FLOAT),
                   data: normals.to_unsafe.as(Void*))

    GL.enable_vertex_attrib_array.call(normal_attribute.to_u32)

    # Refer to the starting point of drawable data
    GL.vertex_attrib_pointer(attribute: normal_attribute.to_u32)

    horizontal_angle = 3.14_f32
    vertical_angle = 0.0_f32

    position = GLM.vec3_static(0,0,5, StaticArray(Float32, 3).new(0))
    model = GLM::Mat4Static.identity(StaticArray(Float32, 16).new(0))

    rotation_angle : Float32 = 0.0_f32

    rotation = GLM::Mat4Static.identity(StaticArray(Float32, 16).new(0))

    temp_buffer = uninitialized Float32[16]
    temp_model = GLM::Mat4Static.identity(temp_buffer)
    transform_buffer = uninitialized Float32[16]
    transform = GLM::Mat4Static.identity(transform_buffer)

    LibSDL.set_relative_mouse_mode(true)

    # declare game loop variables
    total_mouse_rel_x = 0
    total_mouse_rel_y = 0
    count = 0
    start = Time.monotonic
    time = Time.monotonic - start
    time_delta = Time.monotonic - time
    rpm = 30_f32
    seconds_per_minute = 60_f32
    milliseconds_per_second = 1000_f32
    rpms = rpm/seconds_per_minute/milliseconds_per_second

    GC.collect
    while running

      # puts LibGC.get_bytes_since_gc

      time_delta = Time.monotonic - time - start
      time = Time.monotonic - start
      if time_delta.total_milliseconds > 18
        puts LibGC.get_bytes_since_gc
        GC.collect
        puts time_delta.total_milliseconds
      end
      total_mouse_rel_x = 0
      total_mouse_rel_y = 0

      # check user input events
      swapped = false
      checked_mouse = false
      SDL.next_event do |event_type, event|
        case event_type
        when SDL::Event::Quit
          running = false
        when SDL::Event::Keydown
          swapped = true
          case event.key.keysym.sym
          when LibSDL::Keycode::V
            position.x += 0.1
          when LibSDL::Keycode::B
            position.x -= 0.1
          when LibSDL::Keycode::F
            position.y += 0.1
          when LibSDL::Keycode::G
            position.y -= 0.1
          when LibSDL::Keycode::R
            position.z += 0.1
          when LibSDL::Keycode::T
            position.z -= 0.1
          when LibSDL::Keycode::W
            rotation_angle -= 0.05
          when LibSDL::Keycode::S
            rotation_angle += 0.05
          else
          end
        when SDL::Event::Keyup
        when SDL::Event::TextInput
        when SDL::Event::None
        when SDL::Event::Window
        when SDL::Event::MouseMotion
          total_mouse_rel_x += event.motion.xrel
          total_mouse_rel_y += event.motion.yrel
        when SDL::Event::MouseButtonUp
        when SDL::Event::MouseButtonDown
        else

        end
      end
      program.use do
        rot_angle_over_2pi = rotation_angle/(Math::PI)

        horizontal_angle += 0.001_f32 * total_mouse_rel_x
        vertical_angle += 0.001_f32 * total_mouse_rel_y

        # rotate 10x per minute
        # rotate once every 6 seconds
        # rotate 1/6 every 1 second
        # rotate 1/360 every frame's worth of time
        
        rotation_angle = rpms*time.total_milliseconds
        rot_angle_over_2pi = (rotation_angle/(Math::PI))

        GL.uniform1f(loc2, (rot_angle_over_2pi - rot_angle_over_2pi.floor)*Math::PI)

        rotation[0,0] = Math.cos(rotation_angle)
        rotation[0,1] = Math.sin(rotation_angle)
        rotation[1,0] = -Math.sin(rotation_angle)
        rotation[1,1] = rotation[0,0]

        temp_model = rotation.*(model, temp_buffer)
        transform.buffer = mvp_static(
          horizontal_angle: horizontal_angle,
          vertical_angle: vertical_angle,
          position: position,
          model: temp_model,
          buffer: transform.buffer).buffer

        GL.uniform_matrix_4fv(loc3, 1, LibGL::FALSE, transform.buffer.to_unsafe)
        LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

        LibGL.draw_arrays(LibGL::TRIANGLES, 0_u32, triangle.size/3)

      end

      count += 1
      LibSDL.gl_swap_window(window)

    end

      # Disable position attribute use
      GL.disable_vertex_attrib_array.call(0_u32)

      # Unbind the Array Buffer
      GL.bind_buffer.call(LibGL::ARRAY_BUFFER, 0_u32)
  end
end

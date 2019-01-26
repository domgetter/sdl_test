# FIXME: propose moving these into Crystal std-library
struct Float32
  def self.zero
    0_f32
  end

  def self.one
    1_f32
  end
end

struct Float64
  def self.zero
    0_f64
  end

  def self.one
    1_f64
  end
end

module GLM
  def self.deg_to_rad(d)
    d / 180.0 * Math::PI
  end

  struct TVec3Static(T)
    @buffer : StaticArray(T, 3)

    def to_s
      "[\n" +
      "  #{@buffer[0]},\n" +
      "  #{@buffer[0]},\n" +
      "  #{@buffer[0]}\n" +
      "]"
    end

    def self.zero
      new T.zero, T.zero, T.zero
    end

    def to_unsafe
      @buffer
    end

    def initialize(x : T, y : T, z : T)
      @buffer = StaticArray(T, 3).new(T.zero)
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
    end

    def initialize(x : T, y : T, z : T, buffer : StaticArray(T, 3))
      @buffer = buffer
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
    end

    def [](i : Int32)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i]
    end

    def []=(i : Int32, value : T)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i] = value
    end

    def x
      @buffer[0]
    end

    def x=(value : T)
      @buffer[0] = value
    end

    def y
      @buffer[1]
    end

    def y=(value : T)
      @buffer[1] = value
    end

    def z
      @buffer[2]
    end

    def z=(value : T)
      @buffer[2] = value
    end

    def +(v : TVec3Static(T))
      @buffer[0] += v.x
      @buffer[1] += v.y
      @buffer[2] += v.z
      self
    end

    def -(v : TVec3Static(T))
      @buffer[0] -= v.x
      @buffer[1] -= v.y
      @buffer[2] -= v.z
      self
    end

    def -(v : TVec3Static(T), buffer : StaticArray(T, 3))
      TVec3Static.new( self.x - v.x, self.y - v.y, self.z - v.z, buffer)
    end

    def *(s : T)
      @buffer[0] *= s
      @buffer[1] *= s
      @buffer[2] *= s
      self
    end

    def /(s : T)
      @buffer[0] /= s
      @buffer[1] /= s
      @buffer[2] /= s
      self
    end

    def length : T
      Math.sqrt(x * x + y * y + z * z)
    end

    def normalize : TVec3Static(T)
      self / length
    end

    def cross(v : TVec3Static(T)) : TVec3Static
      a = y * v.z - v.y * z
      b = z * v.x - v.z * x
      c = x * v.y - v.x * y
      @buffer[0] = a
      @buffer[1] = b
      @buffer[2] = c
      self
    end

    def cross(v : TVec3Static(T), buffer : StaticArray(T, 3)) : TVec3Static
      TVec3Static.new( y * v.z - v.y * z, z * v.x - v.z * x, x * v.y - v.x * y, buffer)
    end

    def dot(v : TVec3Static(T)) : T
      x * v.x + y * v.y + z * v.z
    end
  end

  struct TVec3(T)
    @buffer : T*

    def to_s
      "[\n" +
      "  #{@buffer[0]},\n" +
      "  #{@buffer[0]},\n" +
      "  #{@buffer[0]}\n" +
      "]"
    end

    def self.zero
      new T.zero, T.zero, T.zero
    end

    def to_unsafe
      @buffer
    end

    def initialize(x : T, y : T, z : T)
      @buffer = Pointer(T).malloc(3)
      @buffer[0] = x
      @buffer[1] = y
      @buffer[2] = z
    end

    def [](i : Int32)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i]
    end

    def []=(i : Int32, value)
      raise IndexError.new if i >= 3 || i < 0
      @buffer[i] = value
    end

    def x
      @buffer[0]
    end

    def x=(value)
      @buffer[0] = value
    end

    def y
      @buffer[1]
    end

    def y=(value)
      @buffer[1] = value
    end

    def z
      @buffer[2]
    end

    def z=(value)
      @buffer[2] = value
    end

    def +(v : TVec3(T))
      TVec3(T).new(x + v.x, y + v.y, z + v.z)
    end

    def -(v : TVec3(T))
      TVec3(T).new(x - v.x, y - v.y, z - v.z)
    end

    def *(a)
      TVec3(T).new(x * a, y * a, z * a)
    end

    def /(a)
      TVec3(T).new(x / a, y / a, z / a)
    end

    def length
      Math.sqrt(x * x + y * y + z * z)
    end

    def normalize
      self / length
    end

    def cross(v : TVec3(T))
      TVec3(T).new(y * v.z - v.y * z,
        z * v.x - v.z * x,
        x * v.y - v.x * y)
    end

    def dot(v : TVec3(T))
      x * v.x + y * v.y + z * v.z
    end
  end

  struct TMat4Static(T)
    @buffer : StaticArray(T, 16)

    def to_s
      puts "["
      print "  "
      4.times {|i| print self[i]; print ','}
      puts
      print "  "
      4.times {|i| print self[i+4]; print ','}
      puts
      print "  "
      4.times {|i| print self[i+8]; print ','}
      puts
      print "  "
      3.times {|i| print self[i+12]; print ','}
      puts self[15]
      puts "]"
    end

    def self.zero : TMat4Static(T)
      TMat4Static(T).new { T.zero }
    end

    def self.identity : TMat4Static(T)
      m = zero
      m[0] = m[5] = m[10] = m[15] = T.one
      m
    end

    def self.zero(buffer : StaticArray(T, 16)) : TMat4Static(T)
      TMat4Static(T).new(buffer) { T.zero }
    end

    def self.identity(buffer : StaticArray(T, 16)) : TMat4Static(T)
      m = zero(buffer)
      m[0] = m[5] = m[10] = m[15] = T.one
      m
    end

    def self.new(&block : Int32 -> T)
      0.upto(15) { |i|
        buffer[i] = yield i
      }
      TMat4Static(T).new(buffer)
    end

    def self.new(buffer : StaticArray(T, 16), &block : Int32 -> T)
      0.upto(15) { |i|
        buffer[i] = yield i
      }
      TMat4Static(T).new(buffer)
    end

    def self.new_with_row_col(buffer : StaticArray(T), &block : (Int32, Int32) -> T) : TMat4Static(T)
      m = TMat4Static(T).new(buffer)
      0.upto(3) { |i|
        0.upto(3) { |j|
          buffer[i + 4*j] = yield i, j
        }
      }
      m
    end

    def initialize(buffer : StaticArray(T, 16))
      @buffer = buffer
    end

    def initialize
      @buffer = StaticArray(T,16).new(T.zero)
    end

    def initialize(&block : Int32 -> T)
      @buffer = StaticArray(T,16).new(T.zero)
      0.upto(15) { |i|
        @buffer[i] = yield i
      }
    end

    def buffer=(buffer : StaticArray(T, 16))
      @buffer = buffer
    end

    def ==(m : TMat4Static(T))
      0.upto(15) { |i|
        return false if @buffer[i] != m.buffer[i]
      }
      return true
    end

    def !=(m : TMat4Static(T))
      !(self == m)
    end

    def *(s : T)
      16.times { |i| @buffer[i] *= s }
      self
    end

    COLUMN_INDICES = [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]]
    ROW_INDICES = [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]]
    COLS = ROW_INDICES.flatten
    INDEX_PAIRS = ROW_INDICES.product(COLUMN_INDICES)

    def *(other : TMat4Static(T))

      temp = uninitialized T[16]
      INDEX_PAIRS.each_with_index do |(a, b), i|
        # puts "temp[#{COLS[i]}] = self[#{a[0]}]*other[#{b[0]}] + self[#{a[1]}]*other[#{b[1]}] + self[#{a[2]}]*other[#{b[2]}] + self[#{a[3]}]*other[#{b[3]}]"
        temp[COLS[i]] = self[a[0]]*other[b[0]] + self[a[1]]*other[b[1]] + self[a[2]]*other[b[2]] + self[a[3]]*other[b[3]]
      end
      16.times {|i| @buffer[i] = temp[i]}
      self

    end

    def *(other : TMat4Static(T), buffer : StaticArray(T, 16))

      temp = TMat4Static.new(buffer)
      INDEX_PAIRS.each_with_index do |(a, b), i|
        temp[COLS[i]] = self[a[0]]*other[b[0]] + self[a[1]]*other[b[1]] + self[a[2]]*other[b[2]] + self[a[3]]*other[b[3]]
      end
      temp

    end

    def buffer
      @buffer
    end

    def [](i)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i]
    end

    def [](row, col)
      self[row + col*4]
    end

    def []=(i, value : T)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i] = value
    end

    def []=(row, col, value : T)
      self[row + col*4] = value
    end
  end

  struct TMat4(T)
    @buffer : T*

    def to_s
      puts "["
      print "  "
      4.times {|i| print self[i]; print ','}
      puts
      print "  "
      4.times {|i| print self[i+4]; print ','}
      puts
      print "  "
      4.times {|i| print self[i+8]; print ','}
      puts
      print "  "
      3.times {|i| print self[i+12]; print ','}
      puts self[15]
      puts "]"
    end

    def self.zero
      TMat4(T).new { T.zero }
    end

    def self.identity
      m = zero
      m[0] = m[5] = m[10] = m[15] = T.one
      m
    end

    def self.new(&block : Int32 -> T)
      m = TMat4(T).new
      p = m.buffer
      0.upto(15) { |i|
        p[i] = yield i
      }
      m
    end

    def self.new_with_row_col(&block : (Int32, Int32) -> T)
      m = TMat4(T).new
      p = m.buffer
      0.upto(3) { |i|
        0.upto(3) { |j|
          # puts "++++++++++++++++++++++++++++"
          # puts i + 4*j
          p[i + 4*j] = yield i, j
          # puts p[i + 4*j]
        }
      }
      m
    end

    def initialize
      @buffer = Pointer(T).malloc(16)
    end
    
    def ==(m : TMat4(T))
      0.upto(15) { |i|
        return false if @buffer[i] != m.buffer[i]
      }
      return true
    end

    def !=(m : TMat4(T))
      !(self == m)
    end

    def *(v)
      m = TMat4(T).new
      0.upto(15) { |i|
        m.buffer[i] = @buffer[i] * v
      }
      m
    end

    def *(m : TMat4(T))
      r = TMat4(T).new_with_row_col { |i, j|
        p1 = @buffer + i
        p2 = m.buffer + 4*j
        # puts "temp[#{i + 4*j}]: self[#{i}]*other[#{4*j}] + self[#{i+4}]*other[#{4*j + 1}] + self[#{i+8}]*other[#{4*j+2}] + self[#{i+12}]*other[#{4*j+3}]"
        p1[0] * p2[0] + p1[4] * p2[1] + p1[8] * p2[2] + p1[12] * p2[3]
      }
      # 16.times {|i| puts r[i]}
      # puts "========================================="
      r
    end

    def buffer
      @buffer
    end

    def [](i)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i]
    end

    def [](row, col)
      self[row + col*4]
    end

    def []=(i, value : T)
      raise IndexError.new if i < 0 || i >= 16
      @buffer[i] = value
    end

    def []=(row, col, value : T)
      self[row + col*4] = value
    end
  end

  alias Mat4 = TMat4(Float32)
  alias Vec3 = TVec3(Float32)
  alias Mat4Static = TMat4Static(Float32)
  alias Vec3Static = TVec3Static(Float32)

  def self.vec3_static(x : Float32, y : Float32, z : Float32, buffer : StaticArray(Float32, 3))
    Vec3Static.new x, y, z, buffer
  end
  
  def self.vec3_static(x : Float32, y : Float32, z : Float32) 
    Vec3Static.new x, y, z
  end
  
  def self.vec3(x, y, z)
    Vec3.new x.to_f32, y.to_f32, z.to_f32
  end

  # OpenGL utility constructors

  def self.perspective(fov_y, aspect, near, far)
    raise ArgumentError.new if aspect == 0 || near == far
    rad = GLM.deg_to_rad(fov_y)
    tan_half_fov = Math.tan(rad / 2)

    m = Mat4.zero
    m[0, 0] = 1 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1 / tan_half_fov.to_f32
    m[2, 2] = -(far+near).to_f32 / (far - near).to_f32
    m[2, 3] = -(2_f32 * far * near) / (far - near)
    m[3, 2] = -1_f32
    m
  end

  def self.perspective_static(fov_y, aspect, near, far, buffer : StaticArray(Float32, 16))
    raise ArgumentError.new if aspect == 0 || near == far
    rad = GLM.deg_to_rad(fov_y)
    tan_half_fov = Math.tan(rad / 2)

    m = Mat4Static.zero(buffer)
    m[0, 0] = 1 / (aspect * tan_half_fov).to_f32
    m[1, 1] = 1 / tan_half_fov.to_f32
    m[2, 2] = -(far+near).to_f32 / (far - near).to_f32
    m[2, 3] = -(2_f32 * far * near) / (far - near)
    m[3, 2] = -1_f32
    m
  end

  def self.look_at(eye : Vec3, center : Vec3, up : Vec3)
    f = (center - eye).normalize
    s = f.cross(up).normalize
    u = s.cross(f)
    m = Mat4.identity
    m[0, 0] = s.x
    m[0, 1] = s.y
    m[0, 2] = s.z
    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(eye)
    m[1, 3] = -u.dot(eye)
    m[2, 3] = f.dot(eye)
    m
  end

  def self.look_at_static(eye : Vec3Static, center : Vec3Static, up : Vec3Static, buffer : StaticArray(Float32, 16))
    f_buffer = uninitialized Float32[3]
    u_buffer = uninitialized Float32[3]
    s_buffer = uninitialized Float32[3]
    f = (center.-(eye, f_buffer)).normalize
    s = f.cross(up, s_buffer).normalize
    u = s.cross(f, u_buffer)
    m = Mat4Static.identity(buffer)
    # center is old f

    m[0, 0] = s.x
    m[0, 1] = s.y
    m[0, 2] = s.z
    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(eye)
    m[1, 3] = -u.dot(eye)
    m[2, 3] = f.dot(eye)
    m
  end

  def self.look_at_static(eye : Vec3Static, center : Vec3Static, up : Vec3Static)
    f_buffer = uninitialized Float32[3]
    u_buffer = uninitialized Float32[3]
    s_buffer = uninitialized Float32[3]
    f = (center.-(eye, f_buffer)).normalize
    s = f.cross(up, s_buffer).normalize
    u = s.cross(f, u_buffer)
    m = Mat4Static.identity
    # center is old f

    m[0, 0] = s.x
    m[0, 1] = s.y
    m[0, 2] = s.z
    m[1, 0] = u.x
    m[1, 1] = u.y
    m[1, 2] = u.z
    m[2, 0] = -f.x
    m[2, 1] = -f.y
    m[2, 2] = -f.z
    m[0, 3] = -s.dot(eye)
    m[1, 3] = -u.dot(eye)
    m[2, 3] = f.dot(eye)
    m
  end
end


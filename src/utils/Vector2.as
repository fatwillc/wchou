package utils {

  /** A 2-dimensional vector representation, because Point sucks. */
  public class Vector2 {
    
    public var x:Number;
    public var y:Number;
    
    public function Vector2(x:Number = 0, y:Number = 0)  {
      this.x = x;
      this.y = y;
    }
    
    /** Length of this vector. */
    public function length():Number {
      return Math.sqrt(x*x + y*y);
    }
    
    /** Dot product of this vector and v. */
    public function dot(v:Vector2):Number {
      return x * v.x + y * v.y;
    }
    
    /** Sets the values of this vector. */
    public function put(x:Number, y:Number):void {
      this.x = x;
      this.y = y;
    }
    
    /** Copies over values of 'v'. */
    public function copy(v:Vector2):void {
      this.x = v.x;
      this.y = v.y;
    }
    
    /** Normalizes this vector to a length of r. */
    public function normalize(r:Number = 1.0):void {
      var s:Number = r / length();
      
      x *= s;
      y *= s;
    }
    
    /** [this] *= s. */
    public function scale(s:Number):void {
      x *= s;
      y *= s;
    }
    
    /** [this] + [v] as a new Vector2. */
    public function add(v:Vector2):Vector2 {
      return new Vector2(x + v.x, y + v.y);
    }
    
    /** [this] - [v] as a new Vector2. */
    public function subtract(v:Vector2):Vector2 {
      return new Vector2(x - v.x, y - v.y);
    }
    
    /** [this] += [v]*s. */
    public function acc(v:Vector2, s:Number):void {
      x += v.x * s;
      y += v.y * s;
    }
    
    /** [this] = [0,0]. */
    public function zero():void {
      x = y = 0;
    }
  }
}
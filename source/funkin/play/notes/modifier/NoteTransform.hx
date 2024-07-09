package funkin.play.notes.modifier;

/**
 * Class that contains note transform data
 */
class NoteTransform
{
  /**
   * X position
   */
  public var x:Float;

  /**
   * Y position
   */
  public var y:Float;

  public function new(x:Float, y:Float)
  {
    this.x = x;
    this.y = y;
  }

  public function add(other:NoteTransform):NoteTransform
  {
    return new NoteTransform(this.x + other.x, this.y + other.y);
  }

  public function sub(other:NoteTransform):NoteTransform
  {
    return new NoteTransform(this.x - other.x, this.y - other.y);
  }

  public function mul(other:NoteTransform):NoteTransform
  {
    return new NoteTransform(this.x * other.x, this.y * other.y);
  }

  public function div(other:NoteTransform):NoteTransform
  {
    return new NoteTransform(this.x / other.x, this.y / other.y);
  }
}

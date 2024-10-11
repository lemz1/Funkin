package funkin.data.charting;

class ClassEntry implements IClassRegistryEntry
{
  public var id:String;

  public function new(id:String)
  {
    this.id = id;
  }

  public function destroy():Void {}

  public function toString():String
  {
    return id;
  }
}

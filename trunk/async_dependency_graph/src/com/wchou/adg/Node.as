package com.wchou.adg
{
  public class Node
  {
    public var name:String;

    public var method:Function;

    public var callback:Function;

    public var traversed:Boolean;

    public var edgeTo:Vector.<Node>;

    public function Node(name:String, method:Function, callback:Function)
    {
      this.name = name;
      this.method = method;
      this.callback = callback;

      traversed = false;

      edgeTo = new Vector.<Node>();
    }

    public function connectTo(node:Node):void
    {
      edgeTo.push(node);
    }

    public function disconnectFrom(node:Node):void
    {
      var i:int = edgeTo.indexOf(node);

      if (i >= 0)
        edgeTo.splice(i, 1);
    }
    
    public function hasEdgeFrom(nodes:Vector.<Node>):Boolean
    {
      for each (var otherNode:Node in nodes)
      {
        if (otherNode.edgeTo.indexOf(this) >= 0)
          return true;
      }
      
      return false;
    }
  }
}
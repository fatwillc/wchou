package com.wchou.adg
{
  /**
   * A light-weight asynchronous dependency graph that allows elegant handling 
   * and execution of multiple event-driven asynchronous method calls with 
   * dependencies by through representation as a directed graph.
   * 
   * Asynchronous method calls are represented as "nodes".
   * 
   * Dependencies between two "nodes" are represented as "edges", where
   * an edge (A, B) means that A will only execute once B has been.
   * 
   * Nodes contain the asynchronous method as a "method" property, which needs 
   * to have a signature function(fn:Function), within which the "fn" 
   * parameter is assigned as the async callback.
   * 
   * To use:
   * 1. Create the AsyncDependencyGraph object.
   * 2. Add all the asynchronous methods you want to call as "nodes".
   * 3. Create dependencies between the nodes as "edges".
   * 4. Run AsyncDependencyGraph.execute().
   * 
   * Example:
   * --------------------------------------------------------------------------
   * var adg:AsyncDependencyGraph = new AsyncDependencyGraph(this);
   * 
   * adg.addNode("google", 
   *   function(callback:Function):void {
   *     var loader:URLLoader = new URLLoader();
   *     loader.addEventListener(Event.COMPLETE, callback);
   *     loader.load(new URLRequest("http://www.google.com"));
   *   }, function(e:Event):void {
   *     trace("Google");
   *   });
   * 
   * adg.addNode("yahoo", 
   *   function(callback:Function):void {
   *     var loader:URLLoader = new URLLoader();
   *     loader.addEventListener(Event.COMPLETE, callback);
   *     loader.load(new URLRequest("http://www.yahoo.com"));
   *   }, function(e:Event):void {
   *     trace("Yahoo");
   *   });
   * 
   * adg.addEdge("google", "yahoo");
   * 
   * adg.execute();
   * --------------------------------------------------------------------------
   * 
   * @author William Chou
   */
  public class AsyncDependencyGraph
  {
    private var context:Object;

    private var nodes:Object;

    private var executed:Boolean;

    /**
     * Create a new asynchronous dependency graph.
     * 
     * Use "var adg = new AsyncDependencyGraph(this)" in order to allow
     * the asynchronous methods and their callbacks to have access to the
     * caller's scope.
     * 
     * @param context The "this" object within the function body of the
     *                asynchronous functions and their callbacks.
     */
    public function AsyncDependencyGraph(context:Object)
    {
      this.context = context;

      nodes = new Object();
      
      executed = false;
    }

    /**
     * Add a node to the graph.
     * 
     * @param name     A string identifier of this node.
     * @param method   The asynchronous method.
     * @param callback The callback to the asynchronous method.
     */
    public function addNode(name:String, method:Function, callback:Function = null):void
    {
      if (name == null || method == null)
        throw new Error("'name' and 'call' parameters must not be null.");

      if (executed)
        throw new Error("Cannot add edges once execution has started.");

      var node:Node = new Node(name, method, callback);
      nodes[name] = node;
    }

    /**
     * Add an edge (from, to) between two existing nodes to the graph.
     * 
     * @param from The name of the node to draw the edge from.
     * @param to   The name of the node to draw the edge to.
     */
    public function addEdge(from:String, to:String):void
    {
      if (nodes[from] == null || nodes[to] == null)
        throw new Error("Nodes must be added to graph before adding edges.");

      if (from == to)
        throw new Error("Cannot add self-directed edge.");

      if (executed)
        throw new Error("Cannot add edges once execution has started.");

      nodes[from].connectTo(nodes[to]);
    }
    
    /**
     * Begins execution of the graph starting with nodes that have no
     * outgoing edges.
     * 
     * @return True if there is at least one node with no outgoing edges.
     *         Returns false otherwise.
     */
    public function execute():Boolean
    {
      if (executed)
        throw new Error("Cannot execute while another execution is in progress.");

      for each (var node:Node in nodes)
      {
        if (node.edgeTo.length == 0)
        {
          node.traversed = true;
          node.method(dependencyCallback(node));
          
          executed = true;
        }
      }

      return executed;
    }

    /**
     * Checks if the graph has a cycle by performing a topological sort.
     * This is important because nodes that in a cycle will not get executed
     * due to circular dependency.
     * 
     * For algorithm details:
     * @see http://en.wikipedia.org/wiki/Topological_sorting
     * 
     * @return True if the graph is cyclic, false otherwise.
     */
    public function hasCycle():Boolean
    {
      // First, split nodes into those with incoming edges (G) and without (S).
      var G:Vector.<Node> = new Vector.<Node>();
      for each (var node:Node in nodes)
        G.push(node);

      var S:Vector.<Node> = new Vector.<Node>();
      for each (var g:Node in G)
      {
        if (!g.hasEdgeFrom(G)) {
          S.push(node);
          G.splice(G.indexOf(g), 1);
        }
      }

      // Next, repeatedly remove nodes in (G) that have no incoming edges.
      while (S.length > 0)
      {
        var s:Node = S.pop();

        for each (var t:Node in s.edgeTo)
        {
          if (!t.hasEdgeFrom(G))
          {
            S.push(t);
            G.splice(G.indexOf(t), 1);
          }
        }
      }

      // If we can remove all nodes from (G) in this manner, it is acyclic.
      return G.length > 0;
    }

    private function dependencyCallback(node:Node):Function
    {
      return function(...args):void
      {
        if (node.callback != null)
          node.callback.apply(context, args);

        for each (var otherNode:Node in nodes)
        {
          if (otherNode.traversed)
            continue;

          otherNode.disconnectFrom(node);
          
          if (otherNode.edgeTo.length == 0)
          {
            otherNode.traversed = true;
            otherNode.method.call(context, dependencyCallback(otherNode));
          }
        }
      };
    }

  }
}
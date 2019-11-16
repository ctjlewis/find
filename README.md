
# find
  
Simple, performant state management for Flutter. 
 
## Usage  
Define a new ID with static `Find.add` method anywhere in the app (before first build), i.e., in `initState()` for the HomePage widget:
```
Find.add(  
  id: "myText",  
  initialState: {  
    "counter": 0,  
  },  
  builder: (Map _state) =>
    Text(_state["counter"].toString()),
);
```
It takes three arguments: a string `id`, a Map `initialState` for the first state, and a `builder` that will build the Widget from the passed state (`_state`).

Displaying the Widget is done anywhere in code with `Find.byId("myText")`. **That's it!**  The only logic you need to worry about is ensuring you call Find.add() before using Find.byId(), and initState overrides are a good place for this.

To dynamically update the value when a button is pressed:
```
FloatingActionButton(  
  ...
  onPressed: () => FindData.byId("myText").update(
    "counter", // ID
    (_counter) => _counter + 1 // state transition fn
  ),
  ...
)
```
Note that `Find.add` must have been called before the Scaffold containing that FloatingActionButton is built. In the Widget building out the Scaffold, just override `initState` and set up the ID.

## Examples
There is an example located at `/example`, which is the default Flutter application except the state logic is replaced with Find.  The regular Flutter application, as it comes, is located at `/example_default` for comparison.
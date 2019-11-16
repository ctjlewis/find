
# find  
### Under development. *Not optimized.*
  
Simple, performant state management for Flutter. 
  
# Usage  
Define a new ID with static `Find.add` method anywhere in the app (before first build), i.e., in `initState()`:
```
Find.add(  
  id: "myText",  
  initial: {  
    "counter": 0,  
  },  
  builder: (Map _data) =>
    Text(_data["counter"].toString()),
);
```
It takes three arguments: a string `id`, a Map `initial` for the first state, and a `builder` that will build the Widget from the passed state (`_data`).

Displaying the Widget is done anywhere in code with `Find.byId("myText")`. **That's it!**

To dynamically update the value when a button is pressed:
```
FloatingActionButton(  
  onPressed: () => FindData.byId("myText").update(
    "counter", // ID
    (_counter) => _counter + 1), // state transition fn
  ...
)
```


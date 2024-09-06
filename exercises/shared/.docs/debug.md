# Debug

YAMLScript has a builtin `DBG` function that can be useful for debugging your
solution code.
It takes any number of arguments and prints them to the console on stderr.
It returns the last argument so you can use it inline in your code.


You can use the `.>` inline operator that is a shortcut for `.DBG()`.

Here's an example code file:

```yaml
# file: program.ys

!yamlscript/v0

defn do-it(nums):
  x =: 5

  DBG: -'my vars' x nums

  nums: .map(\(_ * x)).>
        .reverse().>
        .map(str).>
        .join(' - ')

say: do-it(3 .. 5)
```

When you run this code with `ys`, you will see the following output:

```txt
>>>
"my vars"
5
(3 4 5)
<<<
>>>(15 20 25)<<<
>>>(25 20 15)<<<
>>>("25" "20" "15")<<<
25 - 20 - 15
```


## Compilation

Another common way to figure out a problem is to look at the Clojure code that
your YAMLScript code is compiled to.

You can do this by running the `ys` command-line interpreter with the `-c` flag.

Here's what the above `program.ys` file looks like when compiled:

```clojure
$ ys -c program.ys
(defn do-it [nums]
 (let [x 5]
  (DBG "my vars" x nums)
  (join
   (DBG
    (+map
     (DBG (reverse (DBG (+map nums (fn [& [_1]] (mul+ _1 x))))))
     str))
   " - ")))
(say (do-it (rng 3 5)))
```

You can see clearly how the `.>` operator compiled to the `DBG` function call.

# Todd-s-Calculator
This project is a challenge from Zappos for intern candidates. The task is to implement a calculator app.

This calculator takes in use input in infix notation (what we mostly use for mathematical expressions), turn it into Reverse Polish notation (what's more convenient for a computer program to handle), and calculates the result. 

The usage of this calculator is pretty simple intuitive. Just enter the math expression and hit the "=" button. However, the input has to be a legitimate math expression. For example, if you try to input something like "3+2-+÷2)", it will not let you.

This calculator can be seen as a simplified scientific calculator, in the sense that it can take in a whole line of mathematical expression (less than or equal to 32 bit), and evaluate the whole expression. It knows the proper order of operations (for example, 1 + 2 * 3 would return 7, while a regular hand held four function calculator would give the answer 9), and given its data structure behind the scene, it will be easy to put new operations (say, permutation/combination) and new constants (pi, or e) in the calculator, and make it even more powerful.

Since it's almost Valentine's Day, I put a little Easter Egg in the app for the occasion. If the result of your expression is 2.14 or 214, the whole color scheme of the calculator will turn into a cute rosy pink. Happy Valentine's Day!

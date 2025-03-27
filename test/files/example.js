// This script is a demo that uses all JavaScript keywords and operators in context

function demoOperatorsAndKeywords() {
    let a = 10;
    let b = 20;
    let result = a + b * 2 / (5 - 3) % 4;
    result++;
    result--;
    result **= 2;
  
    if (a < b && b > 15 || a === 10) {
      a += 5;
      b -= 3;
      a <<= 1;
      b >>= 1;
      a &= b;
      b |= a;
    } else {
      a ^= b;
    }
  
    let isTrue = true ? 'yes' : 'no';
    let nullish = null ?? 'default';
    let optional = { nested: { value: 42 } };
    let val = optional?.nested?.value;
  
    try {
      if (a === 15) {
        throw new Error('Test error');
      }
    } catch (e) {
      console.error(e);
    } finally {
      console.log('Cleanup');
    }
  
    for (let i = 0; i < 5; i++) {
      if (i % 2 === 0) continue;
      console.log(i);
    }
  
    switch (a) {
      case 10:
        console.log('Ten');
        break;
      default:
        console.log('Other');
    }
  
    const obj = {
      get value() { return this._val; },
      set value(v) { this._val = v; },
      _val: 123,
      method() { return 'method'; },
    };
  
    delete obj._val;
  
    class MyClass extends Object {
      constructor() {
        super();
        this.field = 'data';
      }
    }
  
    const instance = new MyClass();
    console.log(instance instanceof MyClass);
  
    const arr = [1, 2, 3];
    const [first, ...rest] = arr;
    const fn = (x) => x * 2;
    const map = new Map();
    map.set('key', 'value');
  
    const promise = new Promise((resolve, reject) => {
      setTimeout(() => resolve('done'), 100);
    });
  
    async function asyncFunc() {
      await promise;
    }
  
    void asyncFunc();
  
    debugger;
    console.log('Done');
  }
  
  demoOperatorsAndKeywords();
  
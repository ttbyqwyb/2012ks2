#include <iostream>
using namespace std;

int main() {
  int a, b;
  cin >> a >> b;
  for (; b--; ) ++a;
  cout << a << endl;
  return 0;
}

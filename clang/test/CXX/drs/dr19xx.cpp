// RUN: %clang_cc1 -std=c++98 %s -verify -fexceptions -fcxx-exceptions -pedantic-errors
// RUN: %clang_cc1 -std=c++11 %s -verify -fexceptions -fcxx-exceptions -pedantic-errors
// RUN: %clang_cc1 -std=c++14 %s -verify -fexceptions -fcxx-exceptions -pedantic-errors
// RUN: %clang_cc1 -std=c++1z %s -verify -fexceptions -fcxx-exceptions -pedantic-errors

namespace std { struct type_info; }

namespace dr1902 { // dr1902: 3.7
  struct A {};
  struct B {
    B(A);
#if __cplusplus >= 201103L
        // expected-note@-2 {{candidate}}
#endif

    B() = delete;
#if __cplusplus < 201103L
        // expected-error@-2 {{extension}}
#endif

    B(const B&) // expected-note {{deleted here}}
#if __cplusplus >= 201103L
        // expected-note@-2 {{candidate}}
#else
        // expected-error@+2 {{extension}}
#endif
        = delete;

    operator A();
  };

  extern B b1;
  B b2(b1); // expected-error {{call to deleted}}

#if __cplusplus >= 201103L
  // This is ambiguous, even though calling the B(const B&) constructor would
  // both directly and indirectly call a deleted function.
  B b({}); // expected-error {{ambiguous}}
#endif
}

namespace dr1903 {
  namespace A {
    struct a {};
    int a;
    namespace B {
      int b;
    }
    using namespace B;
    namespace {
      int c;
    }
    namespace D {
      int d;
    }
    using D::d;
  }
  namespace X {
    using A::a;
    using A::b;
    using A::c;
    using A::d;
    struct a *p;
  }
}

namespace dr1909 { // dr1909: yes
  struct A {
    template<typename T> struct A {}; // expected-error {{member 'A' has the same name as its class}}
  };
  struct B {
    template<typename T> void B() {} // expected-error {{constructor cannot have a return type}}
  };
  struct C {
    template<typename T> static int C; // expected-error {{member 'C' has the same name as its class}} expected-error 0-1{{extension}}
  };
  struct D {
    template<typename T> using D = int; // expected-error {{member 'D' has the same name as its class}} expected-error 0-1{{extension}}
  };
}

namespace dr1940 { // dr1940: yes
#if __cplusplus >= 201103L
static union {
  static_assert(true, "");  // ok
  static_assert(false, ""); // expected-error {{static_assert failed}}
};
#endif
}

namespace dr1941 { // dr1941: 3.9
#if __cplusplus >= 201402L
template<typename X>
struct base {
  template<typename T>
  base(T a, T b, decltype(void(*T()), 0) = 0) {
    while (a != b) (void)*a++;
  }

  template<typename T>
  base(T a, X x, decltype(void(T(0) * 1), 0) = 0) {
    for (T n = 0; n != a; ++n) (void)X(x);
  }
};

struct derived : base<int> {
  using base::base;
};

struct iter {
  iter operator++(int);
  int operator*();
  friend bool operator!=(iter, iter);
} it, end;

derived d1(it, end);
derived d2(42, 9);
#endif
}

namespace dr1947 { // dr1947: yes
#if __cplusplus >= 201402L
unsigned o = 0'01;  // ok
unsigned b = 0b'01; // expected-error {{invalid digit 'b' in octal constant}}
unsigned x = 0x'01; // expected-error {{invalid suffix 'x'01' on integer constant}}
#endif
}

#if __cplusplus >= 201103L
// dr1948: yes
// FIXME: This diagnostic could be improved.
void *operator new(__SIZE_TYPE__) noexcept { return nullptr; } // expected-error{{exception specification in declaration does not match previous declaration}}
#endif

namespace dr1959 { // dr1959: 3.9
#if __cplusplus >= 201103L
  struct b;
  struct c;
  struct a {
    a() = default;
    a(const a &) = delete; // expected-note 2{{deleted}}
    a(const b &) = delete; // not inherited
    a(c &&) = delete; // expected-note {{deleted}}
    template<typename T> a(T) = delete;
  };

  struct b : a { // expected-note {{copy constructor of 'b' is implicitly deleted because base class 'dr1959::a' has a deleted copy constructor}}
    using a::a;
  };

  a x;
  b y = x; // expected-error {{deleted}}
  b z = z; // expected-error {{deleted}}

  // FIXME: It's not really clear that this matches the intent, but it's
  // consistent with the behavior for assignment operators.
  struct c : a {
    using a::a;
    c(const c &);
  };
  c q(static_cast<c&&>(q)); // expected-error {{call to deleted}}
#endif
}

namespace dr1968 { // dr1968: yes
#if __cplusplus >= 201103L
  static_assert(&typeid(int) == &typeid(int), ""); // expected-error{{not an integral constant expression}}
#endif
}

namespace dr1991 { // dr1991: 3.9
#if __cplusplus >= 201103L
  struct A {
    A(int, int) = delete;
  };

  struct B : A {
    using A::A;
    B(int, int, int = 0);
  };

  // FIXME: As a resolution to an open DR against P0136R1, we treat derived
  // class constructors as better than base class constructors in the presence
  // of ambiguity.
  B b(0, 0); // ok, calls B constructor
#endif
}

// dr1994: dup 529

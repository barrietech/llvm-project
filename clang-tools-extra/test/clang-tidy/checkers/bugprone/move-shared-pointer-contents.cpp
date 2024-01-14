// RUN: %check_clang_tidy %s bugprone-move-shared-pointer-contents %t -- -config="{CheckOptions: {bugprone-move-shared-pointer-contents.SharedPointerClasses: '::std::shared_ptr;my::OtherSharedPtr;'}}"

// Some dummy definitions we'll need.

namespace std {

using size_t = int;

template <typename> struct remove_reference;
template <typename _Tp> struct remove_reference { typedef _Tp type; };
template <typename _Tp> struct remove_reference<_Tp &> { typedef _Tp type; };
template <typename _Tp> struct remove_reference<_Tp &&> { typedef _Tp type; };

template <typename _Tp>
constexpr typename std::remove_reference<_Tp>::type &&move(_Tp &&__t) {
  return static_cast<typename std::remove_reference<_Tp>::type &&>(__t);
}

template <typename T>
struct shared_ptr {
  shared_ptr();
  T *get() const;
  explicit operator bool() const;
  void reset(T *ptr);
  T &operator*() const;
  T *operator->() const;
};

}  // namespace std

namespace my {
template <typename T>
using OtherSharedPtr = std::shared_ptr<T>;
// Not part of the config.
template <typename T>
using YetAnotherSharedPtr = T*;
}  // namespace my

struct Nontrivial {
  int x;
  Nontrivial() : x(2) {}
  Nontrivial(Nontrivial& other) { x = other.x; }
  Nontrivial(Nontrivial&& other) { x = std::move(other.x); }
  Nontrivial& operator=(Nontrivial& other) { x = other.x; }
  Nontrivial& operator=(Nontrivial&& other) { x = std::move(other.x); }
};

// Test cases begin here.

void correct() {
  std::shared_ptr<Nontrivial> p;
  Nontrivial x = *std::move(p);
}

void simpleFinding() {
  std::shared_ptr<Nontrivial> p;
  Nontrivial y = std::move(*p);
}
// CHECK-MESSAGES: :[[@LINE-2]]:18: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

void aliasedType() {
  using nontrivial_ptr = std::shared_ptr<Nontrivial>;
  nontrivial_ptr p;
  Nontrivial x = std::move(*p);
}
// CHECK-MESSAGES: :[[@LINE-2]]:18: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

void configWorks() {
  my::OtherSharedPtr<Nontrivial> p;
  Nontrivial x = std::move(*p);
}
// CHECK-MESSAGES: :[[@LINE-2]]:18: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

void sharedEsquePointerNotInConfig() {
  my::YetAnotherSharedPtr<Nontrivial> p;
  Nontrivial x = std::move(*p);
}


void multiStars() {
  std::shared_ptr<Nontrivial> p;
  int x = 2 * std::move(*p).x * 3;
}
// CHECK-MESSAGES: :[[@LINE-2]]:15: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

template <typename T>
void unresolved() {
  std::shared_ptr<T> p;
  int x = 2 * std::move(*p).x * 3;
}
// CHECK-MESSAGES: :[[@LINE-2]]:15: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

template <typename T>
void unresolvedAsAReference() {
  std::shared_ptr<T> p;
  std::shared_ptr<T>& q = p;
  int x = 2 * std::move(*q).x * 3;
}
// CHECK-MESSAGES: :[[@LINE-2]]:15: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

template <typename T>
void unresolvedAlias() {
  my::OtherSharedPtr<T> p;
  Nontrivial x = std::move(*p);
}
// CHECK-MESSAGES: :[[@LINE-2]]:18: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

void dereferencedGet() {
  std::shared_ptr<Nontrivial> p;
  Nontrivial x = std::move(*p.get());
}
// CHECK-MESSAGES: :[[@LINE-2]]:18: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

template <typename T>
void unresolvedDereferencedGet() {
  std::shared_ptr<T> p;
  T x = std::move(*p.get());
}
// CHECK-MESSAGES: :[[@LINE-2]]:9: warning: don't move the contents out of a shared pointer, as other accessors expect them to remain in a determinate state [bugprone-move-shared-pointer-contents]

template <typename T>
void rawPointer() {
  T* p;
  T x = std::move(*p);
}

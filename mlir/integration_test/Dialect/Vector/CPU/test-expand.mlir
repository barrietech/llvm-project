// RUN: mlir-opt %s -convert-scf-to-std -convert-vector-to-llvm -convert-std-to-llvm | \
// RUN: mlir-cpu-runner -e entry -entry-point-result=void \
// RUN:   -shared-libs=%mlir_integration_test_dir/libmlir_c_runner_utils%shlibext | \
// RUN: FileCheck %s

func @expand16(%base: memref<?xf32>,
               %mask: vector<16xi1>,
	       %pass_thru: vector<16xf32>) -> vector<16xf32> {
  %e = vector.expandload %base, %mask, %pass_thru
    : memref<?xf32>, vector<16xi1>, vector<16xf32> into vector<16xf32>
  return %e : vector<16xf32>
}

func @entry() {
  // Set up memory.
  %c0 = constant 0: index
  %c1 = constant 1: index
  %c16 = constant 16: index
  %A = alloc(%c16) : memref<?xf32>
  scf.for %i = %c0 to %c16 step %c1 {
    %i32 = index_cast %i : index to i32
    %fi = sitofp %i32 : i32 to f32
    store %fi, %A[%i] : memref<?xf32>
  }

  // Set up pass thru vector.
  %u = constant -7.0: f32
  %v = constant 7.7: f32
  %pass = vector.broadcast %u : f32 to vector<16xf32>

  // Set up masks.
  %f = constant 0: i1
  %t = constant 1: i1
  %none = vector.constant_mask [0] : vector<16xi1>
  %all = vector.constant_mask [16] : vector<16xi1>
  %some1 = vector.constant_mask [4] : vector<16xi1>
  %0 = vector.insert %f, %some1[0] : i1 into vector<16xi1>
  %1 = vector.insert %t, %0[7] : i1 into vector<16xi1>
  %2 = vector.insert %t, %1[11] : i1 into vector<16xi1>
  %3 = vector.insert %t, %2[13] : i1 into vector<16xi1>
  %some2 = vector.insert %t, %3[15] : i1 into vector<16xi1>
  %some3 = vector.insert %f, %some2[2] : i1 into vector<16xi1>

  //
  // Expanding load tests.
  //

  %e1 = call @expand16(%A, %none, %pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e1 : vector<16xf32>
  // CHECK: ( -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7 )

  %e2 = call @expand16(%A, %all, %pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e2 : vector<16xf32>
  // CHECK-NEXT: ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )

  %e3 = call @expand16(%A, %some1, %pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e3 : vector<16xf32>
  // CHECK-NEXT: ( 0, 1, 2, 3, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7, -7 )

  %e4 = call @expand16(%A, %some2, %pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e4 : vector<16xf32>
  // CHECK-NEXT: ( -7, 0, 1, 2, -7, -7, -7, 3, -7, -7, -7, 4, -7, 5, -7, 6 )

  %e5 = call @expand16(%A, %some3, %pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e5 : vector<16xf32>
  // CHECK-NEXT: ( -7, 0, -7, 1, -7, -7, -7, 2, -7, -7, -7, 3, -7, 4, -7, 5 )

  %4 = vector.insert %v, %pass[1] : f32 into vector<16xf32>
  %5 = vector.insert %v, %4[2] : f32 into vector<16xf32>
  %alt_pass = vector.insert %v, %5[14] : f32 into vector<16xf32>
  %e6 = call @expand16(%A, %some3, %alt_pass)
    : (memref<?xf32>, vector<16xi1>, vector<16xf32>) -> (vector<16xf32>)
  vector.print %e6 : vector<16xf32>
  // CHECK-NEXT: ( -7, 0, 7.7, 1, -7, -7, -7, 2, -7, -7, -7, 3, -7, 4, 7.7, 5 )

  return
}

for (int c1 = 0; c1 <= min(np1 - i, -i + 1); c1 += 1) {
  S_9(c1);
  S_12(c1);
}
for (int c1 = max(0, -i + 2); c1 <= -((-np1 + i + 4294967295) % 4294967296) + 4294967295; c1 += 1) {
  S_9(c1);
  S_10(c1);
  for (int c3 = 0; c3 <= min(19, i + c1 - 3); c3 += 1) {
    S_15(c1, c3);
    for (int c5 = 0; c5 < c3; c5 += 1) {
      S_16(c1, c3, c5);
      S_17(c1, c3, c5);
    }
    S_16(c1, c3, c3);
    S_18(c1, c3);
    S_24(c1, c3);
    S_19(c1, c3);
  }
  if (i + c1 <= 21) {
    S_15(c1, i + c1 - 2);
    for (int c5 = 0; c5 < i + c1 - 2; c5 += 1) {
      S_16(c1, i + c1 - 2, c5);
      S_17(c1, i + c1 - 2, c5);
    }
    S_16(c1, i + c1 - 2, i + c1 - 2);
    S_18(c1, i + c1 - 2);
    S_24(c1, i + c1 - 2);
  }
  S_12(c1);
}

discountPercent(old_price, new_price) {
  return (((old_price - new_price) / old_price) * 100).toStringAsFixed(1);
}

void drawExpandedWidget(Rect b) {
  triangle(b.x + b.w     / 4, b.y + b.h     / 4,
           b.x + b.w * 3 / 4, b.y + b.h     / 4,
           b.x + b.w     / 2, b.y + b.h * 3 / 4);
}

void drawCollapsedWidget(Rect b) {
  triangle(b.x + b.w     / 4, b.y + b.h     / 4,
           b.x + b.w     / 4, b.y + b.h * 3 / 4,
           b.x + b.w * 3 / 4, b.y + b.h     / 2);
}

void drawPartialWidget(Rect b) {
  int dy;
  for (dy = 0; dy <= b.h; dy += 3) {
    line(b.x + b.w     / 4, b.y + dy, 
         b.x + b.w * 3 / 4, b.y + dy);
  }
  line(b.x + b.w     / 4, b.y, 
       b.x + b.w     / 4, b.y + dy);
  line(b.x + b.w * 3 / 4, b.y, 
       b.x + b.w * 3 / 4, b.y + dy);
}
 
int reduce(int dim) {
  if (dim > 200) 
    return dim / 2;
  if (dim > 0)
    return dim - 20;
  return 0;
}

Sz reduce (Sz s) {
  return new Sz(reduce(s.w), reduce(s.h));
}

Rect reduce (Rect r) {
  return new Rect(r.x, r.y, reduce(r.w), reduce(r.h));
}

void text(String s, Pt p) {
  text(s, p.x, p.y);
}

void rect(Rect r) {
  rect(r.x, r.y, r.w, r.h);
}


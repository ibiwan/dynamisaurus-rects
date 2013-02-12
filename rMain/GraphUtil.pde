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
  for (dy = 1; dy < b.h; dy += 3) {
    line(b.x + b.w /   4,  b.y + dy, 
         b.x + b.w * 3/4,  b.y + dy);
  }
  line(b.x + b.w /   4,  b.y + 1, 
       b.x + b.w /   4,  b.y + dy);
  line(b.x + b.w * 3/4,  b.y + 1, 
       b.x + b.w * 3/4,  b.y + dy);
}
 
int reduce(int dim) {
  println(dim);
  //if (dim > 300) return dim / 2;
  if (dim > 0)   return dim - 1;
                 return 0;
}

//void text(String s, Pt p) { text(s, p.x, p.y); }
void rect(Rect r)         { rect(r.x, r.y, r.w, r.h); }
void line(Pt p1, Pt p2)   { line(p1.x, p1.y, p2.x, p2.y); }
void line(Pt p, Sz s)     { line(p.x, p.y, p.x + s.w, p.y + s.h); }
void saneText(String s, Pt p) { text(s, p.x, p.y + useTextSize); }

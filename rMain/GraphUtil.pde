void rect(Rect r)         { rect(r.x, r.y, r.w, r.h); }
void line(Pt p1, Pt p2)   { line(p1.x, p1.y, p2.x, p2.y); }
void line(Pt p, Sz s)     { line(p.x, p.y, p.x + s.w, p.y + s.h); }
void saneText(String s, Pt p) { text(s, p.x, p.y + useTextSize); }


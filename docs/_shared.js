// ── PARTICLES ──
(function(){
  const canvas = document.getElementById('particles');
  if(!canvas) return;
  const ctx = canvas.getContext('2d');
  let pts = [];
  function resize(){ canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
  resize(); window.addEventListener('resize', resize);
  function init(){
    pts = [];
    for(let i=0;i<50;i++) pts.push({
      x:Math.random()*canvas.width, y:Math.random()*canvas.height,
      vx:(Math.random()-0.5)*0.25, vy:(Math.random()-0.5)*0.25,
      r:Math.random()*1.2+0.3, o:Math.random()*0.35+0.1
    });
  }
  init();
  function draw(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    for(const p of pts){
      p.x+=p.vx; p.y+=p.vy;
      if(p.x<0)p.x=canvas.width; if(p.x>canvas.width)p.x=0;
      if(p.y<0)p.y=canvas.height; if(p.y>canvas.height)p.y=0;
      ctx.beginPath(); ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
      ctx.fillStyle=`rgba(0,229,195,${p.o})`; ctx.fill();
    }
    for(let i=0;i<pts.length;i++) for(let j=i+1;j<pts.length;j++){
      const dx=pts[i].x-pts[j].x, dy=pts[i].y-pts[j].y, d=Math.sqrt(dx*dx+dy*dy);
      if(d<130){
        ctx.beginPath(); ctx.moveTo(pts[i].x,pts[i].y); ctx.lineTo(pts[j].x,pts[j].y);
        ctx.strokeStyle=`rgba(0,229,195,${0.05*(1-d/130)})`; ctx.lineWidth=0.5; ctx.stroke();
      }
    }
    requestAnimationFrame(draw);
  }
  draw();
})();

// ── TABS ──
function switchTab(id, btn){
  const panel = document.getElementById('panel-'+id);
  if(!panel) return;
  document.querySelectorAll('.tab-panel').forEach(p=>p.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(b=>{ b.classList.remove('active'); b.setAttribute('aria-selected','false'); });
  panel.classList.add('active');
  btn.classList.add('active');
  btn.setAttribute('aria-selected','true');
}

// ── COPY ──
function copyCode(btn){
  const raw = btn.closest('.code-block').querySelector('.code-body').innerText;
  navigator.clipboard.writeText(raw).then(()=>{
    btn.textContent='Copied!'; btn.classList.add('copied');
    setTimeout(()=>{ btn.textContent='Copy'; btn.classList.remove('copied'); }, 1800);
  });
}

// ── SCROLL REVEAL ──
(function(){
  const obs = new IntersectionObserver(entries=>{
    entries.forEach(e=>{ if(e.isIntersecting){ e.target.classList.add('show'); obs.unobserve(e.target); } });
  }, {threshold:0.08});
  document.querySelectorAll('.reveal').forEach(el=>obs.observe(el));
})();

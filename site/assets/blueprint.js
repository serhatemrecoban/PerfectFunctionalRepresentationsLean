/* Progressive enhancement only: all statements and edges are static HTML. */
(() => {
  'use strict';
  const canvas = document.getElementById('graph-canvas');
  if (!canvas) return;
  const controls = document.querySelector('.graph-controls');
  const viewSelect = document.getElementById('graph-view');
  const entrySelect = document.getElementById('graph-entry');
  const preview = document.getElementById('graph-preview');
  const label = document.getElementById('zoom-label');
  const zoomIn = document.getElementById('zoom-in');
  const zoomOut = document.getElementById('zoom-out');
  const minScale = .05;
  const maxScale = 2;
  const initialPreview = preview.innerHTML;
  let scale = 1;
  let currentView = 'all';
  let selected = '';
  let drag = null;
  controls.hidden = false;
  const active = () => document.querySelector(`.graph-view[data-view="${currentView}"]`);
  const svg = () => active().querySelector('svg');
  function zoom(value, anchor = {x:canvas.clientWidth / 2, y:canvas.clientHeight / 2}) {
    const previous = scale;
    scale = Math.min(maxScale, Math.max(minScale, value));
    const bounds = svg().viewBox.baseVal;
    const x = anchor && (canvas.scrollLeft + anchor.x) / previous;
    const y = anchor && (canvas.scrollTop + anchor.y) / previous;
    svg().style.width = `${bounds.width * scale}px`;
    svg().style.height = `${bounds.height * scale}px`;
    if (anchor) {
      canvas.scrollLeft = x * scale - anchor.x;
      canvas.scrollTop = y * scale - anchor.y;
    }
    label.textContent = `${Math.round(scale * 100)}%`;
    zoomOut.disabled = scale <= minScale;
    zoomIn.disabled = scale >= maxScale;
  }
  function fit() { zoom(Math.min(1, (canvas.clientWidth - 24) / svg().viewBox.baseVal.width), false); }
  function readable() {
    zoom(Math.max(.85, Math.min(1, (canvas.clientWidth - 24) / svg().viewBox.baseVal.width)), false);
    canvas.scrollLeft = (svg().viewBox.baseVal.width * scale - canvas.clientWidth) / 2;
  }
  function highlight(id) {
    const neighbors = new Set([id]);
    active().querySelectorAll('.graph-edge').forEach(edge => {
      const hit = id && (edge.dataset.from === id || edge.dataset.to === id);
      edge.classList.toggle('is-highlighted', Boolean(hit));
      edge.classList.toggle('is-muted', Boolean(id && !hit));
      if (hit) { neighbors.add(edge.dataset.from); neighbors.add(edge.dataset.to); }
    });
    active().querySelectorAll('.graph-node').forEach(node => {
      node.classList.toggle('is-selected', node.dataset.entry === id);
      node.classList.toggle('is-neighbor', node.dataset.entry !== id && neighbors.has(node.dataset.entry));
      node.classList.toggle('is-muted', Boolean(id && !neighbors.has(node.dataset.entry)));
    });
  }
  function changeView(value) {
    currentView = value;
    document.querySelectorAll('.graph-view').forEach(view => { view.hidden = view.dataset.view !== value; });
    viewSelect.value = value;
    scale = 1;
    readable();
    canvas.scrollTop = 0;
    highlight(selected);
  }
  function select(id, locate = false, updateHash = true) {
    const template = document.getElementById(`preview-${id}`);
    if (!template) return;
    selected = id;
    if (!active().querySelector(`[data-entry="${id}"]`)) changeView('all');
    preview.replaceChildren(template.content.cloneNode(true));
    entrySelect.value = id;
    highlight(id);
    if (updateHash) history.replaceState(null, '', `#all-${id}`);
    if (locate) {
      const node = active().querySelector(`[data-entry="${id}"] rect`);
      canvas.scrollLeft = (node.x.baseVal.value + node.width.baseVal.value / 2) * scale - canvas.clientWidth / 2;
      canvas.scrollTop = (node.y.baseVal.value + node.height.baseVal.value / 2) * scale - canvas.clientHeight / 2;
    }
  }
  document.querySelectorAll('.graph-node').forEach(node => node.addEventListener('click', event => {
    if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
    event.preventDefault();
    select(node.dataset.entry);
  }));
  viewSelect.addEventListener('change', () => { selected = ''; entrySelect.value = ''; preview.innerHTML = initialPreview; changeView(viewSelect.value); history.replaceState(null, '', location.pathname); });
  entrySelect.addEventListener('change', () => { if (entrySelect.value) select(entrySelect.value, true); });
  zoomIn.addEventListener('click', () => zoom(scale * 1.25));
  zoomOut.addEventListener('click', () => zoom(scale / 1.25));
  document.getElementById('zoom-fit').addEventListener('click', fit);
  document.getElementById('zoom-readable').addEventListener('click', readable);
  document.getElementById('graph-reset').addEventListener('click', () => {
    selected = ''; entrySelect.value = ''; preview.innerHTML = initialPreview;
    changeView('all'); history.replaceState(null, '', location.pathname);
  });
  canvas.addEventListener('pointerdown', event => {
    if (event.pointerType !== 'mouse' || event.button !== 0 || event.target.closest('a')) return;
    drag = {x:event.clientX, y:event.clientY, left:canvas.scrollLeft, top:canvas.scrollTop};
    canvas.setPointerCapture(event.pointerId);
    canvas.classList.add('is-dragging');
  });
  canvas.addEventListener('pointermove', event => {
    if (!drag) return;
    canvas.scrollLeft = drag.left - event.clientX + drag.x;
    canvas.scrollTop = drag.top - event.clientY + drag.y;
  });
  const endDrag = () => { drag = null; canvas.classList.remove('is-dragging'); };
  canvas.addEventListener('pointerup', endDrag);
  canvas.addEventListener('pointercancel', endDrag);
  canvas.addEventListener('lostpointercapture', endDrag);
  // Zoom only this viewport. Modified/horizontal wheel gestures remain native.
  canvas.addEventListener('wheel', event => {
    if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || drag ||
        !Number.isFinite(event.deltaY) || event.deltaY === 0 ||
        Math.abs(event.deltaX) > Math.abs(event.deltaY)) return;
    event.preventDefault();
    const unit = event.deltaMode === 1 ? 16 : event.deltaMode === 2 ? canvas.clientHeight : 1;
    const delta = Math.max(-240, Math.min(240, event.deltaY * unit));
    const rect = canvas.getBoundingClientRect();
    const x = Math.max(0, Math.min(canvas.clientWidth, event.clientX - rect.left - canvas.clientLeft));
    const y = Math.max(0, Math.min(canvas.clientHeight, event.clientY - rect.top - canvas.clientTop));
    zoom(scale * Math.exp(-delta * .002), {x, y});
  }, {passive:false});
  window.addEventListener('hashchange', () => {
    const id = location.hash.replace(/^#all-/, '');
    if (document.getElementById(`preview-${id}`)) select(id, true, false);
  });
  readable();
  const initial = location.hash.replace(/^#all-/, '');
  if (document.getElementById(`preview-${initial}`)) select(initial, true, false);
})();

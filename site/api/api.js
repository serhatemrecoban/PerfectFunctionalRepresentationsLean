"use strict";
const query = document.getElementById("api-query");
const counter = document.getElementById("api-count");
const entries = Array.from(document.querySelectorAll("[data-api-entry]"));
if (query && counter) {
  const indexed = entries.map(element => ({element, text: element.dataset.search.toLowerCase()}));
  const search = () => {
    const terms = query.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
    let count = 0;
    for (const item of indexed) {
      const matches = terms.every(term => item.text.includes(term));
      item.element.hidden = !matches;
      if (matches) count += 1;
    }
    counter.textContent = `${count} of ${entries.length} declarations${terms.length ? " match your search" : " available"}.`;
  };
  query.addEventListener("input", search);
  search();
}

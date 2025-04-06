function populateStyles() {
  const select = document.getElementById("styleSelect");
  select.innerHTML = "";
  Object.keys(sizeTables).forEach(key => {
    const option = document.createElement("option");
    option.value = key;
    option.innerText = key;
    select.appendChild(option);
  });
}

function renderTable(sizeList, highlightSize = "") {
  const tbody = document.getElementById("sizeTableBody");
  tbody.innerHTML = "";
  sizeList.forEach(row => {
    const tr = document.createElement("tr");
    if (row.size === highlightSize) tr.classList.add("highlight");
    tr.innerHTML = `<td>${row.size}</td><td>${row.length}</td><td>${row.chest}</td><td>${row.shoulder}</td><td>${row.sleeve}</td>`;
    tbody.appendChild(tr);
  });
}

function recommendSize() {
  const style = document.getElementById("styleSelect").value;
  const data = sizeTables[style];
  const height = parseFloat(document.getElementById("height").value);
  const chest = parseFloat(document.getElementById("chest").value);
  const idealChestWidth = (chest + 12) / 2;

  const candidates = data.filter(s => s.chest >= idealChestWidth);
  if (candidates.length === 0) {
    document.getElementById("result").innerText = "無法推薦尺寸，請聯繫客服";
    renderTable(data);
    return;
  }

  const estimatedLength = height * 0.42;
  const bestMatch = candidates.reduce((prev, curr) => {
    const prevDiff = Math.abs(prev.length - estimatedLength);
    const currDiff = Math.abs(curr.length - estimatedLength);
    return currDiff < prevDiff ? curr : prev;
  });

  document.getElementById("result").innerHTML = 
    `推薦尺寸：<strong>${bestMatch.size}</strong><br>` +
    `依據胸圍推算胸寬：約 ${idealChestWidth.toFixed(1)} cm<br>` +
    `預估衣長：約 ${estimatedLength.toFixed(1)} cm`;

  renderTable(data, bestMatch.size);
}

populateStyles();
renderTable(sizeTables[Object.keys(sizeTables)[0]]);

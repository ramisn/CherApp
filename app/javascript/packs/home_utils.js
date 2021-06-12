function formatMoney(amount, decimalCount = 2, thousands = ',') {
  let i = parseInt(amount = Math.abs(Number(amount) || 0).toFixed(decimalCount)).toString();
  let j = (i.length > 3) ? i.length % 3 : 0;
  return `$${(j ? i.substr(0, j) + thousands : '')}${i.substr(j).replace(/(\d{3})(?=\d)/g, `$1${thousands}`)}`;
}

function annualIncomeWithFriends(amount, numberOfFriends) {
  const constant = 0.004167;
  const elevationConstant = (1 + constant) ** 360;
  const annualIncomeAmount = (0.8 * amount * ((constant * elevationConstant) / (elevationConstant - 1))) / numberOfFriends;
  return formatMoney(annualIncomeAmount);
}

export {
          formatMoney, annualIncomeWithFriends,
       };

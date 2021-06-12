const DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

function formatedMinutes(minutes) {
  return minutes > 9 ? minutes : `0${minutes}`;
}

function getAmPm(fullDate) {
  const fullDateHour = fullDate.getHours();
  return fullDateHour >= 12 ? 'PM' : 'AM';
}

function getTwelveFormatTime(fullDate) {
  const fullDateHour = fullDate.getHours();

  return (fullDateHour > 12) ? (fullDateHour - 12) : (fullDateHour);
}

function getFormatedHour(fullDate) {
  const dateMinutes = formatedMinutes(fullDate.getMinutes());
  const AMPM = getAmPm(fullDate);
  const simpleHour = getTwelveFormatTime(fullDate);

  return `${simpleHour}:${dateMinutes} ${AMPM}`;
}

function getFormatedDate(fullDate) {
  const day = fullDate.getDate();
  const month = fullDate.getMonth() + 1;
  const year = fullDate.getFullYear();

  return `${month}/${day}/${year}`;
}

function daysDiferrence(fullDate) {
  const currentDay = new Date().getDate();
  const dateDay = fullDate.getDate();

  return Math.abs(currentDay - dateDay);
}

function isSameYear(fullDate) {
  const currentYear = new Date().getFullYear();
  const dateYear = fullDate.getFullYear();

  return (currentYear === dateYear);
}

function isSameMonth(fullDate) {
  const currentMonth = new Date().getMonth();
  const dateMonth = fullDate.getMonth();

  return (currentMonth === dateMonth);
}

function isDateInCurrentDay(fullDate) {
  return isSameYear(fullDate) && isSameMonth(fullDate) && daysDiferrence(fullDate) === 0;
}

function isDateInCurrentWeek(fullDate) {
  return isSameYear(fullDate) && isSameMonth(fullDate) && daysDiferrence(fullDate) < 6;
}

function getHourDayOrDate(fullDate) {
  const dateDay = fullDate.getDay();
  let formatedDate = null;

  if (isDateInCurrentDay(fullDate)) {
    formatedDate = getFormatedHour(fullDate);
  } else if (isDateInCurrentWeek(fullDate)) {
    formatedDate = DAYS[dateDay];
  } else {
    formatedDate = getFormatedDate(fullDate);
  }

  return formatedDate;
}

export { getHourDayOrDate };

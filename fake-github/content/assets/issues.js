const lastIssueIdToHide = 2659;
const issuesToHide = 11;
const firstLoadIndicator = 'FIRST_LOAD';

const firstLoad = isFirstLoad();
localStorage.setItem(firstLoadIndicator, false);

$('#issues').ready(() => {
  if (firstLoad) {
    for (i = lastIssueIdToHide; i > lastIssueIdToHide - issuesToHide; i--) {
      $(`#issue_${i}`).hide();
    }
  }

  $('#issues').show();
});

$('#star').ready(() => {
  $('#star').click(() => localStorage.setItem(firstLoadIndicator, true));
});

$('document').ready(() => {
  if (firstLoad) {
    $('.issue-count').text(20 - issuesToHide);
  }
  else {
    $('.issue-count').text(20);
  }
});

function isFirstLoad() {
  let indicator = localStorage.getItem(firstLoadIndicator);
  if (indicator == null) return true;
  else return String(indicator).toLowerCase() == 'true';
}

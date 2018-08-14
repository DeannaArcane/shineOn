({
  onTabClick: function (component, event, helper) {
    event.preventDefault();
    $A.get('e.pdffiller_sf:evtTabClick').fire({clickedTab: component.get('v.currentTab')});
  }
});
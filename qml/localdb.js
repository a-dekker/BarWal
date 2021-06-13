.import QtQuick.LocalStorage 2.0 as LS

function connectDB() {
  // connect to the local database
  return LS.LocalStorage.openDatabaseSync(
    "barwal",
    "1.0",
    "Barwal Database",
    100000
  );
}

function initializeDB() {
  // initialize DB connection
  var db = connectDB();

  // run initialization queries
  db.transaction(function (tx) {
    // create table
    tx.executeSql(
      "CREATE TABLE IF NOT EXISTS barcode(Name TEXT, Type TEXT, Description TEXT, Code TEXT, GroupName TEXT, Icon BLOB, ComboIndex INTEGER)"
    );
    tx.executeSql("CREATE UNIQUE INDEX IF NOT EXISTS uid ON barcode(Name)");
    tx.executeSql(
      "CREATE TABLE IF NOT EXISTS barcode_group(GroupName TEXT, Icon BLOB)"
    );
    tx.executeSql(
      "CREATE UNIQUE INDEX IF NOT EXISTS gid ON barcode_group(GroupName)"
    );
  });
  return db;
}

/***************************************/
/*** SQL functions for Barcode handling ***/
/***************************************/

// select barcodes and push them into the barcodelist
function readBarcodes(group) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "SELECT Name, Type, Description, Code, ComboIndex FROM barcode where GroupName =?  ORDER BY Name COLLATE NOCASE;",
      [group]
    );
    for (var i = 0; i < result.rows.length; i++) {
      barcodePage.appendBarcode(
        result.rows.item(i).Name,
        result.rows.item(i).Type,
        result.rows.item(i).Description,
        result.rows.item(i).Code,
        result.rows.item(i).ComboIndex
      );
    }
  });
}

function readBarcodeGroups() {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "SELECT GroupName FROM barcode_group ORDER BY GroupName COLLATE NOCASE;"
    );
    for (var i = 0; i < result.rows.length; i++) {
      groupPage.appendGroup(result.rows.item(i).GroupName);
    }
  });
}

function removeBarcode(name) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql("delete FROM barcode where Name = ? ;", [name]);
    tx.executeSql("COMMIT;");
  });
}

function removeBarcodeGroup(name) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql("delete FROM barcode_group where GroupName = ? ;", [name]);
    result = tx.executeSql("delete FROM barcode where GroupName = ? ;", [name]);
    tx.executeSql("COMMIT;");
  });
}

// save barcode group
function writeBarcodeGroup(groupname, icon) {
  var db = connectDB();
  var result;
  icon = null;

  try {
    db.transaction(function (tx) {
      tx.executeSql(
        "INSERT INTO barcode_group (GroupName, Icon) VALUES (?, ?);",
        [groupname, icon]
      );
      tx.executeSql("COMMIT;");
      result = tx.executeSql(
        "SELECT GroupName FROM barcode_group WHERE GroupName=?;",
        [groupname]
      );
    });

    return result.rows.item(0).GroupName;
  } catch (sqlErr) {
    return "ERROR";
  }
}

// insert barcode
function writeBarcode(name, type, description, code, groupname, icon, comboindex) {
  var db = connectDB();
  var result;
  icon = null;

  try {
    db.transaction(function (tx) {
      tx.executeSql(
        "INSERT INTO barcode (Name, Type, Description, Code, GroupName, Icon, ComboIndex) VALUES (?, ?, ?, ?, ?, ?, ?);",
        [name, type, description, code, groupname, icon, comboindex]
      );
      tx.executeSql("COMMIT;");
      result = tx.executeSql("SELECT Name FROM barcode WHERE Name=?;", [name]);
    });

    return result.rows.item(0).Name;
  } catch (sqlErr) {
    return "ERROR";
  }
}

// update barcode
function updateBarcode(name, type, description, code, groupname, icon, comboindex, name_org) {
  var db = connectDB();
  var result;
  icon = null;

  try {
    db.transaction(function (tx) {
      tx.executeSql(
        "UPDATE barcode set Name = ?, Type = ?, Description = ?, Code = ?, ComboIndex = ? where Name = ?;",
        [name, type, description, code, comboindex, name_org]
      );
      // and delete
      tx.executeSql("COMMIT;");
      result = tx.executeSql("SELECT Name FROM barcode WHERE GroupName=?;", [name]);
    });

    return result.rows.item(0).Name;
  } catch (sqlErr) {
    return "ERROR";
  }
}
// update barcodegroup
function updateBarcodeGroup(name, name_org) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql("update barcode_group set GroupName = ? where GroupName = ?;", [name, name_org]);
    result = tx.executeSql("update barcode set GroupName = ? where GroupName = ?;", [name, name_org]);
    tx.executeSql("COMMIT;");
  });
}


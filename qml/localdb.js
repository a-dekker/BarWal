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
    tx.executeSql(
      "CREATE TABLE IF NOT EXISTS zint_codes(ZintCode INT, Description TEXT)"
    );
    tx.executeSql(
      "CREATE UNIQUE INDEX IF NOT EXISTS code ON zint_codes(ZintCode)"
    );
    var rs = tx.executeSql("SELECT * FROM zint_codes");
    if (rs.rows.length === 0) {
      initZintCodes();
    }
    // temporary remove the old "zint code: " prefix
    tx.executeSql(
      "UPDATE barcode set Type = substr(Type,instr(Type,':')+2) where Type like '%: %'"
    );
  });
  return db;
}

/*************************************
 * Initialize the zint_codes table
 ************************************/
function initZintCodes() {
  var db = connectDB();
  db.transaction(function (tx) {
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (1, "Code 11")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (2, "Standard 2of5")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (3, "Interleaved 2of5")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (4, "IATA 2of5")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (6, "Data Logic")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (7, "Industrial 2of5")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (8, "Code 39")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (9, "Extended Code 39")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (13, "EAN")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (14, "EAN + Check")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (16, "GS1-128")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (18, "Codabar")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (20, "Code 128")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (21, "Leitcode")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (22, "Identcode")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (23, "Code 16k")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (24, "Code 49")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (25, "Code 93")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (28, "Flattermarken")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (29, "GS1 DataBar Omni")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (30, "GS1 DataBar Ltd")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (31, "GS1 DataBar Exp")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (32, "Telepen Alpha")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (34, "UPC-A")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (35, "UPC-A + Check")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (37, "UPC-E")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (38, "UPC-E + Check")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (40, "Postnet")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (47, "MSI Plessey")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (49, "FIM")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (50, "Logmars")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (51, "Pharma One-Track")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (52, "PZN")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (53, "Pharma Two-Track")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (55, "PDF417")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (56, "Compact PDF417")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (57, "Maxicode")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (58, "QR Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (60, "Code 128-B")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (63, "AP Standard Customer")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (66, "AP Reply Paid")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (67, "AP Routing")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (68, "AP Redirection")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (69, "ISBN")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (70, "RM4SCC")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (71, "Data Matrix")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (72, "EAN-14")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (73, "VIN")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (74, "Codablock-F")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (75, "NVE-18")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (76, "Japanese Post")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (77, "Korea Post")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (79, "GS1 DataBar Stack")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (80, "GS1 DataBar Stack Omni")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (81, "GS1 DataBar Exp Stack")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (82, "Planet")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (84, "MicroPDF")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (85, "USPS Intelligent Mail")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (86, "UK Plessey")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (87, "Telepen Numeric")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (89, "ITF-14")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (90, "KIX Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (92, "Aztec Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (93, "DAFT Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (96, "DPD Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (97, "Micro QR Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (98, "HIBC Code 128")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (99, "HIBC Code 39")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (102, "HIBC Data Matrix")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (104, "HIBC QR Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (106, "HIBC PDF417")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (108, "HIBC MicroPDF417")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (110, "HIBC Codablock-F")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (112, "HIBC Aztec Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (115, "DotCode")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (116, "Han Xin Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (121, "RM Mailmark")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (128, "Aztec Runes")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (129, "Code 32")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (130, "Comp EAN")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (131, "Comp GS1-128")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (132, "Comp DataBar Omni")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (133, "Comp DataBar Ltd")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (134, "Comp DataBar Exp")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (135, "Comp UPC-A")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (136, "Comp UPC-E")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (137, "Comp DataBar Stack")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (138, "Comp DataBar Stack Omni")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (139, "Comp DataBar Exp Stack")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (140, "Channel Code")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (141, "Code One")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (142, "Grid Matrix")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (143, "UPNQR")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (144, "Ultracode")'
    );
    tx.executeSql(
      'insert into zint_codes (ZintCode, Description) values (145, "rMQR")'
    );
  });
}

/***************************************/
/*** SQL functions for Barcode handling ***/
/***************************************/

// select barcodes and push them into the barcodelist
function readBarcodes(group) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "SELECT \
           barcode.Name, \
           barcode.Type, \
           barcode.Description, \
           barcode.Code, \
           zint_codes.ZintCode, \
           coalesce(barcode.Icon, '') Icon \
        FROM \
           barcode \
           left OUTER join \
              zint_codes \
              on barcode.Type = zint_codes.Description \
        where \
           barcode.GroupName = ? \
        ORDER BY \
           barcode.Name COLLATE NOCASE",
      [group]
    );
    for (var i = 0; i < result.rows.length; i++) {
      barcodePage.appendBarcode(
        result.rows.item(i).Name,
        result.rows.item(i).Type,
        result.rows.item(i).Description,
        result.rows.item(i).Code,
        result.rows.item(i).ZintCode,
        result.rows.item(i).Icon
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

function readBarcodeList() {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "SELECT Description FROM zint_codes ORDER BY Description COLLATE NOCASE;"
    );
    for (var i = 0; i < result.rows.length; i++) {
      editCodePage.appendBarcodeFromList(result.rows.item(i).Description, i);
    }
  });
}

function readBarcodeOnlyList() {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "SELECT Description FROM zint_codes ORDER BY Description COLLATE NOCASE;"
    );
    for (var i = 0; i < result.rows.length; i++) {
      addCodePage.appendBarcodeOnlyFromList(result.rows.item(i).Description);
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
    var result = tx.executeSql(
      "delete FROM barcode_group where GroupName = ? ;",
      [name]
    );
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
function writeBarcode(name, type, description, code, groupname, icon) {
  var db = connectDB();
  var result;
  icon = null;

  try {
    db.transaction(function (tx) {
      tx.executeSql(
        "INSERT INTO barcode (Name, Type, Description, Code, GroupName, Icon) VALUES (?, ?, ?, ?, ?, ?);",
        [name, type, description, code, groupname, icon]
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
function updateBarcode(
  name,
  type,
  description,
  code,
  groupname,
  icon,
  name_org
) {
  var db = connectDB();
  var result;
  icon = null;

  try {
    db.transaction(function (tx) {
      tx.executeSql(
        "UPDATE barcode set Name = ?, Type = ?, Description = ?, Code = ? where Name = ?;",
        [name, type, description, code, name_org]
      );
      tx.executeSql("COMMIT;");
      result = tx.executeSql("SELECT Name FROM barcode WHERE GroupName=?;", [
        name,
      ]);
    });
  } catch (sqlErr) {
    return "ERROR";
  }
}
// update barcodegroup
function updateBarcodeGroup(name, name_org) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "update barcode_group set GroupName = ? where GroupName = ?;",
      [name, name_org]
    );
    result = tx.executeSql(
      "update barcode set GroupName = ? where GroupName = ?;",
      [name, name_org]
    );
    tx.executeSql("COMMIT;");
  });
}

// import icon as base64
function updateIcon(name, base64_image) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "update barcode set Icon = ? where Name = ?;",
      [base64_image, name]
    );
  });
}

// remove icon
function removeIcon(name) {
  var db = connectDB();

  db.transaction(function (tx) {
    var result = tx.executeSql(
      "update barcode set Icon = null where Name = ?;",
      [name]
    );
  });
}

/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DropboxController {
    global DropboxController() {

    }
    global static Dropbox_for_SF.DropboxController.Item commitUpload(String root, String uploadId, String dstPath, String filename) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Item commitUpload(String root, String uploadId, String dstPath, String filename, Long fileSize) {
        return null;
    }
    global static Dropbox_for_SF.DropboxController.Item createFolder(String root, String name) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Item createFolder(String root, String path, String name) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Item deletePath(String root, String path) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Updates delta(String root, String cursor, String path) {
        return null;
    }
    @RemoteAction
    global static String download(String root, String path, String file) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.ConnectedState getConnectedState(Id objectId) {
        return null;
    }
    @RemoteAction
    global static String getPreviewAttachmentId(String root, String filename, String revision) {
        return null;
    }
    @RemoteAction
    global static void incrementChatterShareCount(String root) {

    }
    global static Dropbox_for_SF.DropboxController.InitData initApp(String objectId) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.InitData initApp(String objectId, Boolean createFolder) {
        return null;
    }
    @RemoteAction
    global static String latestCursor(String root, String path) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.DirectoryDetails listDirectoryDetails(String root, String path, Boolean includeDeleted) {
        return null;
    }
    global static Dropbox_for_SF.DropboxController.Item rename(String root, String oldName, String newName) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Item rename(String root, String oldName, String newPath, String newName) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.Item restore(String root, String path) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.DropboxController.DirectoryDetails search(String root, String query) {
        return null;
    }
    @RemoteAction
    global static List<Dropbox_for_SF.DropboxController.Person> searchPeople(String qry, List<String> emails) {
        return null;
    }
    @RemoteAction
    global static void shareByEmail(String url, String message, String filename, List<String> emails) {

    }
    @RemoteAction
    global static void shareToChatter(String root, String url, String message, String filename) {

    }
    @RemoteAction
    global static String shares(String root, String path) {
        return null;
    }
    @RemoteAction
    global static Dropbox_for_SF.ChunkInfo uploadChunk(String root, String uploadId, Long offset, Blob chunk) {
        return null;
    }
global class ConnectedState {
    global ConnectedState() {

    }
}
global class DirectoryDetails {
    global DirectoryDetails() {

    }
}
global class InitData {
    global InitData() {

    }
}
global class Item {
    global Item() {

    }
}
global class Person {
    global Person() {

    }
}
global class Updates {
    global Updates() {

    }
}
}

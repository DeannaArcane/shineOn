*,
:after,
:before {
    box-sizing: border-box
}
body {
    font-family: Arial
}
body a:hover {
    text-decoration: none;
    color: black
}
.dadadocs-content-wrapper {
    position: relative
}
.dadadocs_button {
    display: block;
    width: 150px;
    height: 32px;
    font-size: 12px;
    color: white;
    border-radius: 3px;
    text-transform: capitalize;
    cursor: pointer;
    border: 1px solid #ff8615;
    background: #ff9000;
    background-image: linear-gradient(#ffa300 0%, #f70 100%)
}
.dadadocs_button:hover {
    background: #ff9e21
}
.dadadocs_button:focus {
    border-color: #ff7700;
    box-shadow: 0 0 5px 1px rgba(255, 119, 0, 0.51);
    outline: none
}
.dadadocs_button:active {
    background: #ff9000;
    background-image: linear-gradient(0deg, #ffa300 0%, #f70 100%)
}
.dadadocs-header {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-pack: justify;
    justify-content: space-between;
    -ms-flex-align: center;
    align-items: center;
    width: 100%;
    padding: 25px 20px;
    background: #fafafa;
    border-bottom: 1px solid #ddd
}
.dadadocs-header__title {
    margin: 0;
    font-size: 16px;
    color: #444
}
.dadadocs-settings {
    display: block;
    padding: 30px 20px;
}
.dadadocs-settings__item {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-pack: justify;
    justify-content: space-between;
    padding: 20px 0;
    border-bottom: 1px solid #dddddd
}
.dadadocs-settings__item:last-child {
    border-bottom: none
}
.dadadocs-settings__item-name {
    margin: 0;
    font-size: 20px;
    font-weight: normal;
    color: #444
}
.dadadocs-settings__item-description {
    margin: 0;
    font-size: 13px;
    color: #888
}
.dadadocs-settings__create-settings {
    width: 210px;
    background: white;
    font-size: 13px;
    font-weight: bold;
    color: #444;
    border-width: 2px
}
.dadadocs-settings__create-settings:hover {
    background: #ff9000;
    color: #fff
}
.dadadocs-settings__create-settings:focus {
    box-shadow: 0 0 5px 1px rgba(255, 119, 0, 0.51);
    outline: none
}
.dadadocs-settings__create-settings:active {
    background: #ff9000;
    background-image: linear-gradient(0deg, #ffa300 0%, #f70 100%)
}
@media all and (max-width: 690px) {
    .dadadocs-settings__create-settings {
        height: 42px
    }
}
.dadadocs-settings-option__item {
    display: -ms-flexbox;
    display: flex;
    cursor: pointer;
    line-height: 20px;
    -ms-flex-align: center;
    align-items: center;
    font-size: 13px;
    color: #444;
    text-transform: none;
    width: 100%
}
.dadadocs-settings-option__item input {
    margin: 5px;
    z-index:1;
}

/*admin feature specific*/
.dadadocs-feature-settings {
    border: 1px solid red;
    padding: 10px 20px;
}

.dadadocs-settings__feature {
    padding: 20px;
}

.dadadocs-settings__feature-input {
    vertical-align: middle;
    margin-top: -2px;
}

.dadadocs-settings__feature-inner-wrapper {
    padding: 5px 0;
}
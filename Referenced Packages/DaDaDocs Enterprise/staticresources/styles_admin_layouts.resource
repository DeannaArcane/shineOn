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
.dadadocs-layouts {
    display: block;
    padding: 20px;
    -webkit-font-smoothing: antialiased
}
.dadadocs-layouts__title {
    margin: 0;
    padding: 10px 0;
    font-size: 13px;
    font-weight: bold;
    text-transform: uppercase;
    color: #888
}
.dadadocs-layouts__title.dadadocs-layouts__title_order:hover {
    cursor: pointer;
    text-decoration: underline
}
.dadadocs-layouts__options {
    -moz-columns: 250px 3;
    columns: 250px 3;
    padding: 5px 0
}
/*--- style for new footer for layaout component in setting ---*/
.dadadocs-layouts__footer {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-pack: justify;
    -ms-flex-pack: justify;
    justify-content: space-between;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
}
/*--- style for new footer in featers component in settings ---*/
.dadadocs-settings__footer {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-pack: end;
    -ms-flex-pack: end;
    justify-content: flex-end;
    padding: 0px 20px 20px;
}

@media all and (max-width: 700px) {
    .dadadocs-layouts__options {
        -moz-columns: 2;
        columns: 2
    }
}
@media all and (max-width: 500px) {
    .dadadocs-layouts__options {
        -moz-columns: 1;
        columns: 1
    }
}
.dadadocs-option__item {
    width: 100%;
    font-size: 13px;
    line-height: 20px;
    color: #444;
    text-transform: capitalize;
    cursor: pointer
}
.dadadocs-option__item:before {
    content: '';
    display: inline-block;
    width: 16px;
    height: 16px;
    margin-top: 1px;
    margin-right: 10px;
    padding-left: 2px;
    border: 1px solid #aaa;
    border-radius: 3px
}
.dadadocs-option__item_checked:before {
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAICAQAAABq86Y9AAAAaUlEQVQI12NgQAHuRq7XXWegCLlpuLx2+e/ygsGN210FIuQl7/oYKPTPLZ7B5SyQymNg8BN3vQ0U+u9SAJR3PQOWzXO5CBJyawBrctEEmwOGrhMQxhu7fgQLLfjPiGyrnctNl5mhzDA+ANpSLNSY/mBUAAAAAElFTkSuQmCC);
    background-repeat: no-repeat;
    background-position: 2px 3px
}
.dadadocs-option__item_template {
    display: none
}
.g-wrap-loading {
    position: absolute;
    top: -2px;
    bottom: 0;
    left: 0;
    right: 0;
    display: none
}
.g-wrap-loading:before {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    width: 100%;
    height: 100%;
    background: #fff;
    z-index: 119;
    opacity: .70
}
.g-wrap-loading_active {
    display: block
}
.g-loader {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    z-index: 119;
    transform: translate(-50%, -50%)
}
.g-loader__wrapper {
    width: 48px;
    height: 48px;
    margin: 0 auto;
    animation: container-rotate 1568ms linear infinite
}
.g-loader__wrapper:before {
    position: absolute;
    content: '';
    height: 100%;
    width: 100%;
    border: 2px solid #ddd;
    border-radius: 50%
}
.g-loader__layer {
    position: absolute;
    width: 100%;
    height: 100%;
    border-color: #ff9000;
    animation: fill-unfill-rotate 5332ms cubic-bezier(0.4, 0, 0.2, 1) infinite both
}
.g-loader__circle-clipper {
    position: relative;
    width: 50%;
    height: 100%;
    overflow: hidden;
    border-color: inherit
}
.g-loader__circle-clipper .g-loader__circle {
    width: 200%;
    height: 100%;
    border: 2px solid #ff9000;
    border-bottom-color: transparent;
    border-radius: 50%;
    animation: none
}
.g-loader__circle-clipper--left .g-loader__circle {
    left: 0;
    border-right-color: transparent;
    transform: rotate(129deg);
    animation: left-spin 1333ms cubic-bezier(0.4, 0, 0.2, 1) infinite both
}
.g-loader__label {
    font-size: 14px;
    text-align: center;
    margin-top: 6px
}
@keyframes container-rotate {
    to {
        transform: rotate(360deg)
    }
}
@keyframes fill-unfill-rotate {
    12.5% {
        transform: rotate(135deg)
    }
    25% {
        transform: rotate(270deg)
    }
    37.5% {
        transform: rotate(405deg)
    }
    50% {
        transform: rotate(540deg)
    }
    62.5% {
        transform: rotate(675deg)
    }
    75% {
        transform: rotate(810deg)
    }
    87.5% {
        transform: rotate(945deg)
    }
    to {
        transform: rotate(1080deg)
    }
}
@keyframes left-spin {
    from {
        transform: rotate(130deg)
    }
    50% {
        transform: rotate(-5deg)
    }
    to {
        transform: rotate(130deg)
    }
}
@keyframes right-spin {
    from {
        transform: rotate(-130deg)
    }
    50% {
        transform: rotate(5deg)
    }
    to {
        transform: rotate(-130deg)
    }
}
.dadadocs_pagination {
    display: -ms-flexbox;
    display: flex;
    padding: 0;
    list-style: none;
    font-size: 14px
}
.dadadocs_pagination__item {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-align: center;
    align-items: center;
    -ms-flex-pack: center;
    justify-content: center;
    min-width: 24px;
    height: 24px;
    margin: 5px;
    padding: 3px;
    text-align: center;
    color: #444;
    border-radius: 50%;
    border: 1px solid white;
    cursor: pointer;
    text-transform: capitalize
}
.dadadocs_pagination__item:hover {
    border-color: #ff9000
}
.dadadocs_pagination__item_disabled {
    color: #757575;
    pointer-events: none
}
.dadadocs_pagination__item_separator {
    pointer-events: none
}
.dadadocs_pagination__item_prev {
    padding: 5px 10px;
    border-radius: 12px
}
.dadadocs_pagination__item_prev:before {
    content: '\2190';
    display: block;
    margin-right: 5px
}
.dadadocs_pagination__item_next {
    padding: 5px 10px;
    border-radius: 12px
}
.dadadocs_pagination__item_next:after {
    content: '\2192';
    display: block;
    margin-left: 5px
}
.dadadocs_pagination__item_active {
    color: white;
    background: #ff9000;
    border-color: #ff9000
}
.dadadocs_pagination__item_template {
    display: none
}
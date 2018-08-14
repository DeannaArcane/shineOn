*, :before, :after {
    box-sizing: border-box;
}

.g-wrap-loading {
    position: absolute;
    top: -2px;
    bottom: 0;
    left: 0;
    right: 0;
    display: none;
}

.g-wrap-loading_active {
    display: block;
}

.g-wrap-loading:before {
    content: '';
    position: absolute;
    width: 100%;
    height: 100%;
    background: #fff;
    z-index: 119;
    opacity: .80;
}

.g-loader {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    z-index: 119;
    transform: translate(-50%, -50%);
}

.g-loader__wrapper {
    width: 48px;
    height: 48px;
    margin: 0 auto;
    animation: container-rotate 1568ms linear infinite;
}

.g-loader__wrapper:before {
    position: absolute;
    content: '';
    height: 100%;
    width: 100%;
    border: 2px solid #ddd;
    border-radius: 50%;
}

.g-loader__layer {
    position: absolute;
    width: 100%;
    height: 100%;
    border-color: #ff9000;
    animation: fill-unfill-rotate 5332ms cubic-bezier(0.4, 0, 0.2, 1) infinite both;
}

.g-loader__circle-clipper {
    position: relative;
    width: 50%;
    height: 100%;
    overflow: hidden;
    border-color: inherit;
}

.g-loader__circle-clipper .g-loader__circle {
    width: 200%;
    height: 100%;
    border: 2px solid #ff9000;
    border-bottom-color: transparent;
    border-radius: 50%;
    animation: none;
}

.g-loader__circle-clipper--left .g-loader__circle {
    left: 0;
    border-right-color: transparent;
    transform: rotate(129deg);
    animation: left-spin 1333ms cubic-bezier(0.4, 0, 0.2, 1) infinite both;
}

.g-loader__label {
    font-size: 14px;
    text-align: center;
    margin-top: 6px;
}

@keyframes container-rotate {
    to {
        transform: rotate(360deg);
    }
}

@keyframes fill-unfill-rotate {
    12.5% {
        transform: rotate(135deg);
    }
    25% {
        transform: rotate(270deg);
    }
    37.5% {
        transform: rotate(405deg);
    }
    50% {
        transform: rotate(540deg);
    }
    62.5% {
        transform: rotate(675deg);
    }
    75% {
        transform: rotate(810deg);
    }
    87.5% {
        transform: rotate(945deg);
    }
    to {
        transform: rotate(1080deg);
    }
}

@keyframes left-spin {
    from {
        transform: rotate(130deg);
    }
    50% {
        transform: rotate(-5deg);
    }
    to {
        transform: rotate(130deg);
    }
}

@keyframes right-spin {
    from {
        transform: rotate(-130deg);
    }
    50% {
        transform: rotate(5deg);
    }
    to {
        transform: rotate(-130deg);
    }
}
/**
 * Copyright (c) 2017, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * ffhttp_MultipartMimeAttachmentTest
 *
 * Test class for ffhttp_MultipartMimeAttachment.
 */
@isTest
private class ffhttp_MultipartMimeAttachmentTest
{
	static testMethod void testMultipartMimeAttachment()
	{
		Blob fileABlob = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAmEAAAAwMNAAAAAAAAAAAAAAAAFhfI6PAYKCk2R2ZnaoaJmKn4/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AJ1euwWNClEi8WE6TqSxg6S0dsdR2joB5Hcmdd6ywCJo7EzLu2WARGQDAf/Z');
		Blob fileBBlob = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAX/xAAkEAABAwIFBQEAAAAAAAAAAAAFAwQHAgYACMjo8Akoaomp+P/EABYBAQEBAAAAAAAAAAAAAAAAAAADBf/EABwRAAMBAQEBAQEAAAAAAAAAAAECAwQABREhEv/aAAwDAQACEQMRAD8AigArOOQQW3RyxYAPjkSNCsXB8+dHnbYZxgzRYtljV0XQSy43NbxaP0MqNNTl+RdxO/thaHqlnC0RKxBXX06ZQimaCZ5lzOaBQWZnYhR8H9O5Z3b4P1nZmY/rEkk9oet6en2vV0+xsXOmvXopZ1hCGWCvVy7COXLOObNIMxE4Z5ShFPk5TSaqorfkfZNtd+ZeK9n852j6JtLvrLw5znPADw53/9k=');
		Blob fileCBlob = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAMAAwDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAtEAAAAgQLCQAAAAAAAAAAAAAWFwA3OGcYGSk2OUdJZoen8Gl3hoiJmKi4x//EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCc3rsBjgUIgXtYLouoLDnQWTtTpOydAHc5WeKqg8m2TnN7OJAbucLPgbKvKcpvBuziQHrVrpLUS2ot1A//2Q==');

		ffhttp_MultipartMimeAttachment body1 = new ffhttp_MultipartMimeAttachment();
		body1.writeBoundary();
		body1.writeBodyParameter('key', 'value');
		body1.writeBoundary();
		body1.writeFile('key', 'value', 'image/jpeg', fileABlob);
		body1.writeEndBoundary();

		ffhttp_MultipartMimeAttachment body2 = new ffhttp_MultipartMimeAttachment();
		body2.writeBoundary();
		body2.writeBodyParameter('key', 'value');
		body2.writeBoundary();
		body2.writeFile('key', 'value', 'image/jpeg', fileBBlob);
		body2.writeEndBoundary();

		ffhttp_MultipartMimeAttachment body3 = new ffhttp_MultipartMimeAttachment();
		body3.writeBoundary();
		body3.writeBodyParameter('key', 'value');
		body3.writeBoundary();
		body3.writeFile('key', 'value', 'image/jpeg', fileCBlob);
		body3.writeEndBoundary();

		System.assertEquals(body1.getHttpContentType(), 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"');
		System.assertEquals(EncodingUtil.base64Encode((Blob) body1.getHttpContent()), 'LS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiICANCg0KdmFsdWUgIA0KLS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiOyBmaWxlbmFtZT0idmFsdWUiIA0KQ29udGVudC1UeXBlOiBpbWFnZS9qcGVnICANCg0K/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAmEAAAAwMNAAAAAAAAAAAAAAAAFhfI6PAYKCk2R2ZnaoaJmKn4/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AJ1euwWNClEi8WE6TqSxg6S0dsdR2joB5Hcmdd6ywCJo7EzLu2WARGQDAf/ZDQotLTFmZjEzNDQ0ZWQ4MTQwYzdhMzJmYzRlNjQ1MWFhNzZkLS0=');
		System.assertEquals(EncodingUtil.base64Encode((Blob) body2.getHttpContent()), 'LS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiICANCg0KdmFsdWUgIA0KLS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiOyBmaWxlbmFtZT0idmFsdWUiIA0KQ29udGVudC1UeXBlOiBpbWFnZS9qcGVnICANCg0K/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAX/xAAkEAABAwIFBQEAAAAAAAAAAAAFAwQHAgYACMjo8Akoaomp+P/EABYBAQEBAAAAAAAAAAAAAAAAAAADBf/EABwRAAMBAQEBAQEAAAAAAAAAAAECAwQABREhEv/aAAwDAQACEQMRAD8AigArOOQQW3RyxYAPjkSNCsXB8+dHnbYZxgzRYtljV0XQSy43NbxaP0MqNNTl+RdxO/thaHqlnC0RKxBXX06ZQimaCZ5lzOaBQWZnYhR8H9O5Z3b4P1nZmY/rEkk9oet6en2vV0+xsXOmvXopZ1hCGWCvVy7COXLOObNIMxE4Z5ShFPk5TSaqorfkfZNtd+ZeK9n852j6JtLvrLw5znPADw53/9kNCi0tMWZmMTM0NDRlZDgxNDBjN2EzMmZjNGU2NDUxYWE3NmQtLQ==');
		System.assertEquals(EncodingUtil.base64Encode((Blob) body3.getHttpContent()), 'LS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiICANCg0KdmFsdWUgIA0KLS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0KQ29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJrZXkiOyBmaWxlbmFtZT0idmFsdWUiIA0KQ29udGVudC1UeXBlOiBpbWFnZS9qcGVnICANCg0K/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAMAAwDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAtEAAAAgQLCQAAAAAAAAAAAAAWFwA3OGcYGSk2OUdJZoen8Gl3hoiJmKi4x//EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCc3rsBjgUIgXtYLouoLDnQWTtTpOydAHc5WeKqg8m2TnN7OJAbucLPgbKvKcpvBuziQHrVrpLUS2ot1A//2Q0KLS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZC0t');
	}
}
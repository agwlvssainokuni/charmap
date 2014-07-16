/*
 *   Copyright 2011 Norio Agawa
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

package cherry.windows.charset;

import java.io.IOException;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class ListCreatorTest {

	private ApplicationContext appCtx = new ClassPathXmlApplicationContext(
			"config/applicationContext.xml");

	@Test
	public void 出力() throws IOException {
		ListCreator listCreator = appCtx.getBean(ListCreator.class);
		listCreator.createList();
	}

}

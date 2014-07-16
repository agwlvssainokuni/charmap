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
import java.math.BigInteger;
import java.nio.charset.Charset;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cherry.windows.charset.TableParser.Entry;

@Component
public class ListCreator {

	@Autowired
	private TableParser tableParser;

	public void createList() throws IOException {

		Charset ms932 = Charset.forName("MS932");
		Charset cp943 = Charset.forName("CP943");
		Charset win31j = Charset.forName("Windows-31J");

		System.out
				.println("WIN\tUNI\tMS932(1)\tMS932(2)\tCP943(1)\tCP943(2)\tWin31J(1)\tWin31J(2)\tCOMMENT");

		List<Entry> list = tableParser.parse("CP932.TXT");
		for (Entry entry : list) {

			System.out.print(entry.getWinCode());
			System.out.print("\t");
			System.out.print(entry.getUniCode());
			System.out.print("\t");

			BigInteger winCode = new BigInteger(entry.getWinCode(), 16);

			BigInteger bi932x1 = new BigInteger((new String(
					winCode.toByteArray(), ms932)).getBytes(ms932));
			BigInteger bi932x2 = new BigInteger((new String(
					bi932x1.toByteArray(), ms932)).getBytes(ms932));
			System.out.print(winCode.equals(bi932x1));
			System.out.print("\t");
			System.out.print(bi932x1.equals(bi932x2));
			System.out.print("\t");

			BigInteger bi943x1 = new BigInteger((new String(
					winCode.toByteArray(), cp943)).getBytes(cp943));
			BigInteger bi943x2 = new BigInteger((new String(
					bi943x1.toByteArray(), cp943)).getBytes(cp943));
			System.out.print(winCode.equals(bi943x1));
			System.out.print("\t");
			System.out.print(bi943x1.equals(bi943x2));
			System.out.print("\t");

			BigInteger bi31jx1 = new BigInteger((new String(
					winCode.toByteArray(), win31j)).getBytes(win31j));
			BigInteger bi31jx2 = new BigInteger((new String(
					bi31jx1.toByteArray(), win31j)).getBytes(win31j));
			System.out.print(winCode.equals(bi31jx1));
			System.out.print("\t");
			System.out.print(bi31jx1.equals(bi31jx2));
			System.out.print("\t");

			System.out.print(entry.getComment());
			System.out.println();
		}
	}
}

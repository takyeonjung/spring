package kr.ezen.ajax2;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class FileController {
	@RequestMapping("/form.do")
	public String form() {
		return "uploadForm";
	}
	
	// 파일 업로드시 필요한 API : Apache Commons FileUpload
	
	@RequestMapping("/upload.do")
	public String upload(MultipartHttpServletRequest mhr, 
			HttpServletRequest request, Model model) throws IOException {
		
		String repo = "resources/fileRepo";
		
		// 서버의 물리경로 얻어오기                               // OS에 따라 \\(윈도우), //(리눅스)    
		String savePath= request.getServletContext().getRealPath("")+File.separator+repo;
		
		System.out.println(savePath);
		
		Map map = new HashMap();
		
		// mhr은 텍스트 파일, 바이너리 파일의 정보를 모두 얻어올 수 있다.
		Enumeration<String> enu = mhr.getParameterNames();
		
		// 일반 텍스트 파일의 파라미터명(key), 해당 파라미터명의 value값을 가져오기 
		while(enu.hasMoreElements()) {
			String paramName = enu.nextElement();
			String paramValue = mhr.getParameter(paramName);
			
			System.out.println(paramName +":"+paramValue );
			map.put(paramName, paramValue);
			
		}
		
		// 파일
		Iterator<String> iter= mhr.getFileNames();		
		List<String> fileList = new ArrayList<String>();
		
		while(iter.hasNext()) {
			String fileParamName = iter.next();
			System.out.println("fileParamName : " + fileParamName);
			
			// MultipartFile : 파일정보를 갖고 있는 객체
			MultipartFile mFile= mhr.getFile(fileParamName);
			
			String originName = mFile.getOriginalFilename();
			System.out.println("originName : " + originName);
			
			File file = new File(savePath +"\\"+ fileParamName);
			
			if(mFile.getSize() !=0) { // 업로드된 경우
				if(!file.exists()) { // 파일이 존재하지 않으면 최초로 한번만 실행
					if(file.getParentFile().mkdir()) { // savePath에 지정된 폴더(fileRepo) 생성
						file.createNewFile(); // 임시파일 생성
					}//if
				}//if
				
				File uploadFile = new File(savePath +"\\"+originName);
				
				// 중복시 파일명 대체
				if(uploadFile.exists()) {
					originName = System.currentTimeMillis()+"_"+originName;
					uploadFile = new File(savePath +"\\"+originName);
				}
				
				// 실제 파일 업로드하기
				mFile.transferTo(uploadFile);
				fileList.add(originName);
			}// if
		}
		
		map.put("fileList", fileList);
		model.addAttribute("map", map); 
		
		return "uploadResult";
	}
	
	@RequestMapping("/download.do")
	public void download(@RequestParam("fileName") String fileName, HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		String repo = "resources/fileRepo";
		
		// 서버의 물리경로 얻어오기                               // OS에 따라 \\(윈도우), //(리눅스)    
		String savePath= request.getServletContext().getRealPath("")+File.separator+repo;
		
		File file = new File(savePath +"\\"+ fileName);
		
		// 다운로드를 위한 준비과정
		response.setContentLength((int)file.length());
		response.setContentType("application/x-msdownload;charset=utf-8");
		
		response.setHeader("Content-Disposition", "attachment;fileName="+fileName+";");
		response.setHeader("Content-Transfer-Encoding","binary");
//		response.setHeader("Pragma", "no-cache");
//		response.setHeader("Expires", "0");
		
		// 다운로드 처리
		FileInputStream fis = new FileInputStream(file);
		OutputStream out = response.getOutputStream();
		
		byte[] buffer = new byte[1024];
		while(true) {
			int cnt = fis.read(buffer);
			if(cnt == -1) { // 파일의 끝(EOF: End Of File)을 읽으면 -1 
				break;
			}
			out.write(buffer, 0, cnt); // 읽어들인 만큼 스트림에 출력
		}
		
		fis.close();
		out.close();
	}
	
	
	
	
	
	
	
	
}
